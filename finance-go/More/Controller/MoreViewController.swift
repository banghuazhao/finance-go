//
//  MoreViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 1/1/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
    import MBProgressHUD
#endif
import UIKit

import MessageUI
import SafariServices
import Toast_Swift

class MoreViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)

        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()

        var rewardedAd: GADRewardedAd?
        var userDidEarn = false
    #endif

    var moreItems = [MoreItem]()

    let toolsItems = [
        MoreItem(title: "Financial Terms and Definition".localized(), icon: UIImage(named: "icon_info")),
//        MoreItem(title: "Salary Calculator".localized(), icon: UIImage(named: "icon_briefcase.fill")),
//        MoreItem(title: "More Tools".localized(), icon: UIImage(named: "more")),
    ]

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(MoreItemCell.self, forCellWithReuseIdentifier: "MoreItemCell")
        collectionView.register(MoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MoreHeaderView")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = 80
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        return collectionView
    }()

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More".localized()

        configMoreItems()

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
        }

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                view.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.width.equalToSuperview()
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                    make.centerX.equalToSuperview()
                }
            }
        #endif

        #if !targetEnvironment(macCatalyst)
            NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
}

// MARK: - actions

extension MoreViewController {
    #if !targetEnvironment(macCatalyst)
        @objc func handlePurchaseNotification(_ notification: Notification) {
            bannerView.removeFromSuperview()
        }
    #endif
}

// MARK: - methods

extension MoreViewController {
    fileprivate func configMoreItems() {
        let removeAds = MoreItem(
            title: "Remove Ads".localized(),
            icon: UIImage(named: "icon_see"),
            action: { [weak self] _, _ in
                guard let self = self else { return }
                let removeAdsViewController = RemoveAdsViewController()
                removeAdsViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(removeAdsViewController, animated: true)
            }
        )

        let clearCache = MoreItem(
            title: "Clear Cache".localized(),
            icon: UIImage(named: "icon_trash"),
            action: { [weak self] collectionView, indexPath in
                guard let self = self else { return }
                let alterController = UIAlertController(title: "Clear Cache".localized(), message: "\("Do you want to clear cache".localized())? (\(getCacheDirectorySize()))", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Yes".localized(), style: .default) { _ in
                    clearCacheOfLocal()
                    collectionView.reloadItems(at: [indexPath])
                }
                let action2 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                alterController.addAction(action1)
                alterController.addAction(action2)
                self.present(alterController, animated: true)
            }
        )

        let feedbackItem = MoreItem(
            title: "Feedback".localized(),
            icon: UIImage(named: "icon_feedback")) { [weak self] _, _ in
            guard let self = self else { return }
            let feedbackViewController = FeedbackViewController()
            feedbackViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(feedbackViewController, animated: true)
        }

        let rateThisApp = MoreItem(
            title: "Rate this App".localized(),
            icon: UIImage(named: "icon_rateStar")) { _, _ in
            if let reviewURL = URL(string: "https://itunes.apple.com/app/id\(Constants.AppID.financeGoAppID)?action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
                UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
            }
        }

        let shareThisApp = MoreItem(
            title: "Share this App".localized(),
            icon: UIImage(named: "icon_share")) { [weak self] collectionView, indexPath in
            guard let self = self else { return }
            let textToShare = "Finance Go".localized()

            let image = UIImage(named: "appIcon_finance_go")!

            if let appStoreURL = URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.financeGoAppID)"), UIApplication.shared.canOpenURL(appStoreURL) {
                // Enter link to your app here
                let objectsToShare = [textToShare, appStoreURL, image] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceRect = collectionView.cellForItem(at: indexPath)?.bounds ?? .zero
                    popoverController.sourceView = collectionView.cellForItem(at: indexPath)
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }

        let moreApps = MoreItem(
            title: "More Apps".localized(),
            icon: UIImage(named: "more")) { [weak self] _, _ in
            guard let self = self else { return }
            let moreAppsViewController = MoreAppsViewController()
            moreAppsViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(moreAppsViewController, animated: true)
        }
        
        moreItems = [removeAds, clearCache, feedbackItem, rateThisApp, shareThisApp, moreApps]
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 3.添加header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MoreHeaderView", for: indexPath) as? MoreHeaderView else { return UICollectionReusableView() }
            if indexPath.section == 0 {
                header.titleLabel.text = "General".localized()
            } else {
                header.titleLabel.text = "Tools".localized()
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return moreItems.count
        } else {
            return toolsItems.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreItemCell", for: indexPath) as! MoreItemCell
            cell.moreItem = moreItems[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreItemCell", for: indexPath) as! MoreItemCell
            cell.moreItem = toolsItems[indexPath.row]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            if let action = moreItems[indexPath.row].action {
                action(collectionView, indexPath)
            }
        } else {
            if indexPath.item == 0 {
                let financialTermsAndDefinitionViewController = FinancialTermsAndDefinitionViewController()
                financialTermsAndDefinitionViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(financialTermsAndDefinitionViewController, animated: true)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    // 定义每一个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftInset = view.safeAreaInsets.left + 20
        if Constants.Device.isIphone {
            let width = (view.bounds.width - leftInset*2 - 16*2) / 3 - 1
            return CGSize(width: width, height: 112)
        } else {
            return CGSize(width: 144, height: 112)
        }
    }

    // 定义每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
    }

    // 两行cell之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    // 两列cell之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

#if !targetEnvironment(macCatalyst)

    // MARK: - GADFullScreenContentDelegate

    extension MoreViewController: GADFullScreenContentDelegate {
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            print(#function)
            if userDidEarn {
                let ac = UIAlertController(title: "\("Thanks for Your Support".localized())!", message: "\("We will constantly optimize and maintain our App and make sure users have the best experience".localized()).", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                ac.addAction(action1)
                present(ac, animated: true)
            }
            userDidEarn = false
        }
    }

#endif
