//
//  MenuViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Hue
import Localize_Swift
import SnapKit
import Then
import UIKit

import MessageUI
import SafariServices

import GoogleMobileAds
import SVProgressHUD

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var userDidEarn = false

    var rewardedAd: GADRewardedAd?

    let menuItems = [
        MenuItem(title: "Clear Cache".localized(), icon: UIImage(named: "trash")),
        MenuItem(title: "Feedback".localized(), icon: UIImage(named: "feedback")),
        MenuItem(title: "Rate this App".localized(), icon: UIImage(named: "star")),
        MenuItem(title: "Share this App".localized(), icon: UIImage(named: "share_app")),
        MenuItem(title: "Support this App".localized(), icon: UIImage(named: "support_app")),
    ]

    lazy var backButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "back_button"), for: .normal)
        b.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
    }

    lazy var titleLabel = UILabel().then { label in
        label.font = FontExtension.bigTitle
        label.textColor = .white1
        label.text = "Financial Statements Go".localized()
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tv.separatorStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGradientBackground()
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(titleLabel)
            make.size.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(60)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }

    deinit {
        print("MenuController deinit")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

extension MenuViewController {
    @objc func backToHome() {
        dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell

        if indexPath.row == 0 {
            menuItems[indexPath.row].title = "\("Clear Cache".localized()): \(getCacheDirectorySize())"
        }

        cell.menuItem = menuItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            let alterController = UIAlertController(title: "Clear Cache".localized(), message: "Do you want to clear cache?".localized(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes".localized(), style: .default) { _ in
                clearCacheOfLocal()
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            let action2 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            alterController.addAction(action1)
            alterController.addAction(action2)
            present(alterController, animated: true)
        }

        if indexPath.row == 1 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            guard let url = URL(string: "https://banghuazhao.github.io/Financial-Statements-Go-Website/contact/") else { return }
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }

        if indexPath.row == 2 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            StoreReviewHelper().requestReview()
        }

        if indexPath.row == 3 {
            let textToShare = "Financial Statements Go".localized()

            let image = UIImage(named: "app_icon_180")!

            if let myWebsite = URL(string: "http://itunes.apple.com/app/id\(Constants.appID)") {
                // Enter link to your app here
                let objectsToShare = [textToShare, myWebsite, textToShare, image] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                    popoverController.sourceView = view
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                present(activityVC, animated: true, completion: nil)
            }
        }

        if indexPath.row == 4 {
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            let alterController = UIAlertController(title: "Support this App".localized(), message: "Do you want to watch an advertisement to support this App?".localized(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes".localized(), style: .default) { [weak self] _ in
                guard let self = self else { return }
                SVProgressHUD.show(withStatus: "Loading the advertisement".localized())
                self.rewardedAd = GADRewardedAd(adUnitID: Constants.rewardAdUnitID)
                self.rewardedAd?.load(GADRequest()) { error in
                    SVProgressHUD.dismiss()
                    if let _ = error {
                    } else {
                        self.rewardedAd?.present(fromRootViewController: self, delegate: self)
                    }
                }
            }
            let action2 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            alterController.addAction(action1)
            alterController.addAction(action2)
            present(alterController, animated: true)
        }
    }
}

extension MenuViewController: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        userDidEarn = true
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        SVProgressHUD.dismiss()
        if userDidEarn {
            let ac = UIAlertController(title: "Thanks for Your Support!".localized(), message: "We will constantly optimize and maintain our App and make sure users have the best experience.".localized(), preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            ac.addAction(action1)
            present(ac, animated: true)
        }
        userDidEarn = false
    }
}
