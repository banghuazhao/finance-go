//
//  HistoricalCalendarViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 11/21/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class HistoricalCalendarViewController: FGUIViewController {
    var company: Company?
    var statusBarCoverView = UIView()
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var vc1 = HistoricalEarningCalendarViewController()

    lazy var vc2 = HistoricalEarningCalendarViewController()

    lazy var vc3 = HistoricalEarningCalendarViewController()

    var selectedIndex: Int = 0

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Historical Calendar".localized()

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

        let titles = ["Earning".localized(), "Dividend".localized(), "Stock Split".localized()]
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

extension HistoricalCalendarViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        guard let company = company else { return }

        var str: String = ""

        str += "\("Company".localized()):\t\(company.name) (\(company.symbol))\n"

        str += "\n"

        var calendarType = ""

        if selectedIndex == 0 {
            calendarType = "Earning Calendar".localized()
            str += "\(calendarType):\n"
            str += "\n"

            let calendars = vc1.earningCalendars

            guard calendars.count > 0 else { return }

            str += "\("Date".localized())\t\("EPS Estimated".localized())\t\("EPS".localized())\t\("Surprise".localized())\n"
            for calendar in calendars {
                var label2 = "-"
                var label3 = "-"
                var label4 = "-"
                if let epsEstimated = calendar.epsEstimated {
                    if let company = CompanyStore.shared.item(symbol: calendar.symbol) {
                        label2 = convertDoubleToCurrency(amount: epsEstimated, localeIdentifier: company.localeIdentifier)
                    } else {
                        label2 = convertDoubleToCurrency(amount: epsEstimated)
                    }
                }
                if let eps = calendar.eps {
                    if let company = CompanyStore.shared.item(symbol: calendar.symbol) {
                        label3 = convertDoubleToCurrency(amount: eps, localeIdentifier: company.localeIdentifier)
                    } else {
                        label3 = convertDoubleToCurrency(amount: eps)
                    }
                }
                if let epsEstimated = calendar.epsEstimated, let eps = calendar.eps, epsEstimated != 0 {
                    let change = (eps - epsEstimated) / epsEstimated * 100
                    label4 = String(format: "%.2f%%", change)
                }
                str += "\(calendar.date)\t\(label2)\t\(label3)\t\(label4)\n"
                str += "\n"
            }
        } else if selectedIndex == 1 {
            calendarType = "Dividend Calendar".localized()
            str += "\(calendarType):\n"
            str += "\n"

            let calendars = vc2.dividendCalendars

            guard calendars.count > 0 else { return }

            str += "\("Date".localized())\t\("Record Date".localized())\t\("Payment Date".localized())\t\("Dividend".localized())\n"
            for calendar in calendars {
                var label2 = "-"
                var label3 = "-"
                var label4 = "-"

                if let recordDate = calendar.recordDate {
                    label2 = recordDate
                }
                if let paymentDate = calendar.paymentDate {
                    label3 = paymentDate
                }
                if let dividend = calendar.dividend {
                    label4 = convertDoubleToCurrency(amount: dividend, companySymbol: calendar.symbol)
                }
                str += "\(calendar.date)\t\(label2)\t\(label3)\t\(label4)\n"
                str += "\n"
            }
        } else {
            calendarType = "Stock Split Calendar".localized()
            str += "\(calendarType):\n"
            str += "\n"

            let calendars = vc3.stockSplitCalendars

            guard calendars.count > 0 else { return }

            str += "\("Date".localized())\t\("Numerator".localized())\t\("Denominator".localized())\t\("Ratio".localized())\n"
            for calendar in calendars {
                var label2 = "-"
                var label3 = "-"

                if let numerator = calendar.numerator {
                    label2 = convertDoubleToDecimal(amount: numerator)
                }

                if let denominator = calendar.denominator {
                    label3 = convertDoubleToDecimal(amount: denominator)
                }

                str += "\(calendar.date)\t\(label2)\t\(label3)\t\(calendar.stockSplitRatio)\n"
                str += "\n"
            }
        }

        str += "\n"

        let file = getDocumentsDirectory().appendingPathComponent("\(calendarType) \(company.symbol).txt")

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

extension HistoricalCalendarViewController: JXSegmentedViewDelegate {
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

extension HistoricalCalendarViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            vc1.company = company
            vc1.requestType = .earning
            return vc1
        } else if index == 1 {
            vc2.company = company
            vc2.requestType = .dividend
            return vc2
        } else {
            vc3.company = company
            vc3.requestType = .stockSplit
            return vc3
        }
    }
}
