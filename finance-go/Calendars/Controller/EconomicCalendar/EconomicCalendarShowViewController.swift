//
//  EconomicEconomicCalendarShowViewController.swift
//  Financial Statements Go
//
//  Created by Lulin Y on 2022/1/16.
//  Copyright © 2022 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import SwiftyJSON
import UIKit

class EconomicCalendarShowViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var calendar: EconomicCalendar!

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(EconomicCalendarCell.self, forCellReuseIdentifier: "EconomicCalendarCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Economic Calendar".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
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
    }
}

// MARK: - actions

extension EconomicCalendarShowViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        var str: String = ""
        var fileName: String = ""

        str += "\("Region".localized()): \(calendar.region)"

        str += "\n"

        str += "\("Event".localized()): \(calendar.event)"

        str += "\n"

        str += "\("Date".localized()): \(calendar.date)"

        str += "\n"

        let value: String
        if let actual = calendar.actual, let change = calendar.change, let changePercent = calendar.changePercentage {
            let actualString = convertDoubleToDecimal(amount: actual)
            let changesString = change >= 0 ? "+" + convertDoubleToDecimal(amount: change) : convertDoubleToDecimal(amount: change)
            let changePercentString = change >= 0 ? "(↑" + convertDoubleToDecimal(amount: changePercent) + "%)" : "(↓" + convertDoubleToDecimal(amount: fabs(changePercent)) + "%)"
            let changesStringAll = changesString + " " + changePercentString
            value = actualString + "  " + changesStringAll
        } else {
            value = "-"
        }

        str += "\("Value".localized()): \(value)"

        str += "\n"

        fileName = "\("Economic Calendar".localized()) \(calendar.region) \(calendar.event).txt"

        let file = getDocumentsDirectory().appendingPathComponent(fileName)

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
                                InterstitialAdsRequestHelper.resetRequestCount()
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

extension EconomicCalendarShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EconomicCalendarCell", for: indexPath) as! EconomicCalendarCell
        cell.economicCalendar = calendar
        return cell
    }
}
