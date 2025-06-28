//
//  FeedbackViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/1/16.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import MessageUI
import UIKit

class FeedbackViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var feedbackItems = [FeedbackItem]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(FeedbackItemCell.self, forCellReuseIdentifier: "FeedbackItemCell")
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.separatorColor = UIColor.white3
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if let regionCode = Locale.current.regionCode, regionCode == "CN" {
            feedbackItems = [
                FeedbackItem(
                    title: "微信公众号",
                    detail: "微信公众号 Apps Bay 里留言".localized(),
                    icon: UIImage(named: "icon_wechat")),
                FeedbackItem(
                    title: "电子邮件".localized(),
                    detail: "发送电子邮件给 appsbay@qq.com".localized(),
                    icon: UIImage(named: "icon_email")),
            ]
        } else {
            feedbackItems = [
                FeedbackItem(
                    title: "Facebook Page".localized(),
                    detail: "Send message to Apps Bay Facebook page".localized(),
                    icon: UIImage(named: "icon_facebook")),

                FeedbackItem(
                    title: "Email".localized(),
                    detail: "Write an email to appsbayarea@gmail.com".localized(),
                    icon: UIImage(named: "icon_email")),
            ]
        }
        title = "Feedback".localized()

        view.addSubview(tableView)

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                view.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                }
            }
        #endif

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbackItems.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50 + 16 + 16
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackItemCell", for: indexPath) as! FeedbackItemCell
        cell.feedbackItem = feedbackItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let regionCode = Locale.current.regionCode, regionCode == "CN" {
            if indexPath.row == 0 {
                let alterController = UIAlertController(title: "微信公众号留言".localized(), message: "请在微信中搜索\"Apps Bay\"公众号，关注后即可留言反馈，谢谢！", preferredStyle: .alert)
                let action = UIAlertAction(title: "好的".localized(), style: .cancel, handler: nil)
                alterController.addAction(action)
                present(alterController, animated: true)
            }
            if indexPath.row == 1 {
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["appsbay@qq.com"])
                    mail.setSubject("美股财报新闻通 - 反馈")
                    var bodyString = "\n\n\n\n\n"
                    bodyString += "Version: \(Constants.appVersion)\n"
                    bodyString += "Device: \(Constants.deviceName)\n"
                    bodyString += "iOS Version: \(Constants.iOSVersion)\n"
                    bodyString += "Region: \(Constants.regionCode)\n"
                    bodyString += "Time zone: \(Constants.timeZone)\n"
                    mail.setMessageBody(bodyString, isHTML: false)
                    present(mail, animated: true)
                }
            }
        } else {
            if indexPath.row == 0 {
                let facebookAppURL = URL(string: "fb://profile/\(Constants.facebookPageID)")!
                if UIApplication.shared.canOpenURL(facebookAppURL) {
                    UIApplication.shared.open(facebookAppURL)
                } else {
                    UIApplication.shared.open(URL(string: "https://www.facebook.com/Apps-Bay-104357371640600")!)
                }
            }
            if indexPath.row == 1 {
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["appsbayarea@gmail.com"])
                    mail.setSubject("\("Finance Go".localized()) - \("Feedback".localized())")
                    var bodyString = "\n\n\n\n\n"
                    bodyString += "Version: \(Constants.appVersion)\n"
                    bodyString += "Device: \(Constants.deviceName)\n"
                    bodyString += "iOS Version: \(Constants.iOSVersion)\n"
                    bodyString += "Region: \(Constants.regionCode)\n"
                    bodyString += "Time zone: \(Constants.timeZone)\n"
                    mail.setMessageBody(bodyString, isHTML: false)
                    present(mail, animated: true)
                }
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                let ac = UIAlertController(title: "Thanks for Your Feedback".localized(), message: "We will constantly optimize and maintain our App and make sure users have the best experience".localized(), preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                ac.addAction(action1)
                self.present(ac, animated: true)
            }
        }
    }
}
