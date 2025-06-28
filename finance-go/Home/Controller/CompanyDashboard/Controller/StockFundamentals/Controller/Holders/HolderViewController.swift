//
//  HolderViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/25.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class HolderViewController: FGUIViewController {
    var company: Company?
    var statusBarCoverView = UIView()
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var topInstitutionalHoldersViewController = HolderValueViewController()

    lazy var topMutualFundHoldersViewController = HolderValueViewController()

    var selectedIndex: Int = 0

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Holders".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(statusBarCoverView)
        statusBarCoverView.backgroundColor = .navBarColor
        statusBarCoverView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.topbarHeight + 40)
        }

        setupSegmentedView()
    }

    fileprivate func setupSegmentedView() {
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.backgroundColor = .navBarColor
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let titles = ["Institutional".localized(), "Mutual Fund".localized()]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.titles = titles
        titleDataSource.titleNormalColor = UIColor.white1.alpha(0.7)
        titleDataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        titleDataSource.titleSelectedColor = UIColor.white1
        titleDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 17)
        segmentedDataSource = titleDataSource
        segmentedView.dataSource = titleDataSource

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = UIColor.white1
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - actions

extension HolderViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        guard let company = company else { return }
        var holderProfiles = [HolderProfile]()

        var holderType = "Institutional Holders (Top 25)".localized()
        holderProfiles = topInstitutionalHoldersViewController.holderProfiles
        if selectedIndex == 1 {
            holderType = "Mutual Fund Holders (Top 25)".localized()
            holderProfiles = topMutualFundHoldersViewController.holderProfiles
        }

        guard holderProfiles.count > 0 else { return }

        var str: String = ""

        str += "\("Company".localized()):\t\(company.name) (\(company.symbol))\n"

        str += "\n"

        str += "\(holderType):\n"

        str += "\n"

        for holderProfile in holderProfiles {
            str += "\("Holder".localized()): \(holderProfile.holderName)\n"
            str += "\("Shares".localized()): \(holderProfile.shares)\n"
            str += "\("Date Reported".localized()): \(holderProfile.dateReported)\n"
            str += "\("Change".localized()): \(holderProfile.change)\n"
            str += "\n"
        }

        let file = getDocumentsDirectory().appendingPathComponent("\(holderType) \(company.symbol).txt")

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create share file: \(err)")
        }

        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = (sender.value(forKey: "view") as? UIView)?.bounds ?? .zero
            popoverController.sourceView = sender.value(forKey: "view") as? UIView
        }

        activityVC.completionWithItemsHandler = { (_, completed: Bool, _: [Any]?, error: Error?) in
            if completed {
                if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                    print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
                } else {
                    #if !targetEnvironment(macCatalyst)
                        GADInterstitialAd.load(withAdUnitID: Constants.GoogleAdsID.interstitialAdID, request: GADRequest()) { ad, error in
                            if let error = error {
                                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                return
                            }
                            if let ad = ad {
                                ad.present(fromRootViewController: UIApplication.getTopMostViewController() ?? self)
                            } else {
                                print("interstitial Ad wasn't ready")
                            }
                        }
                    #endif
                }
            } else {
                print("UIAlertController not completed")
            }
        }

        present(activityVC, animated: true, completion: {
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                #if targetEnvironment(macCatalyst)
                    let moreAppsViewController = MoreAppsViewController()
                    moreAppsViewController.isAds = true
                    (UIApplication.getTopMostViewController() ?? self).present(FGUINavigationController(rootViewController: moreAppsViewController), animated: true, completion: nil)
                #endif
            }
        })
    }
}

// MARK: - JXSegmentedViewDelegate

extension HolderViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据
            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        selectedIndex = index
    }
}

extension HolderViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            topInstitutionalHoldersViewController.company = company
            topInstitutionalHoldersViewController.requestType = .institutional
            return topInstitutionalHoldersViewController
        } else {
            topMutualFundHoldersViewController.company = company
            topMutualFundHoldersViewController.requestType = .mutualFund
            return topMutualFundHoldersViewController
        }
    }
}


// MARK: - JXSegmentedListContainerViewListDelegate

extension HolderViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
