//
//  EarningCallTranscript.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/6.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import MJRefresh
import SwiftyJSON
import UIKit

class EarningCallTranscriptViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company?
    var earningCallTranscriptDate: EarningCallTranscriptDate?
    var earningCallTranscript: EarningCallTranscript?
    
    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(EarningCallTranscriptCell.self, forCellReuseIdentifier: "EarningCallTranscriptCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initStateViews()

        title = "Earning Call Transcript".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
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

        if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
            print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
        } else {
            if InterstitialAdsRequestHelper.increaseRequestAndCheckLoadInterstitialAd() {
                #if !targetEnvironment(macCatalyst)
                    GADInterstitialAd.load(withAdUnitID: Constants.GoogleAdsID.interstitialAdID, request: GADRequest()) { ad, error in
                        if let error = error {
                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                            return
                        }
                        if let ad = ad {
                            ad.present(fromRootViewController: self)
                            InterstitialAdsRequestHelper.resetRequestCount()
                        } else {
                            print("interstitial Ad wasn't ready")
                        }
                    }
                #else
                    let moreAppsViewController = MoreAppsViewController()
                    moreAppsViewController.isAds = true
                    present(FGUINavigationController(rootViewController: moreAppsViewController), animated: true, completion: nil)
                    InterstitialAdsRequestHelper.resetRequestCount()
                #endif
            }
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()
    }
}

extension EarningCallTranscriptViewController {
    @objc func fetchDataOnline() {
        guard let company = company, let earningCallTranscriptDate = earningCallTranscriptDate else { return }
        startFetchData()
        let urlString = APIManager.baseURL + "/api/v3/earning_call_transcript/\(company.symbol)"

        let parameters = [
            "quarter": "\(earningCallTranscriptDate.quarter)",
            "year": "\(earningCallTranscriptDate.year)",
            "apikey": Constants.APIKey,
        ]

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(30 * 24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    let jsonArray = json.arrayValue
                    if jsonArray.count == 1 {
                        self.earningCallTranscript = EarningCallTranscript(dict: jsonArray[0])
                    }
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.earningCallTranscript == nil {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.earningCallTranscript == nil {
                    self.showNetworkError()
                }
            }
        }
    }
}

extension EarningCallTranscriptViewController {
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    @objc func share(_ sender: UIBarButtonItem) {
        guard let company = company, let earningCallTranscript = earningCallTranscript else { return }

        var str: String = ""

        str += "\("Company".localized()):\t\(company.name) (\(company.symbol))\n"

        str += "\n"

        str += "\("Earning Call Transcript".localized()):\n"

        str += "\n"

        str += "\("Company Symbol".localized()): \(earningCallTranscript.symbol)\n"
        str += "\("Quarter".localized()): \(earningCallTranscript.quarter)\n"
        str += "\("Year".localized()): \(earningCallTranscript.year)\n"
        str += "\("Date".localized()): \(earningCallTranscript.date)\n"
        str += "\("Content".localized()):\n"
        str += "\(earningCallTranscript.content)\n"
        str += "\n"

        let file = getDocumentsDirectory().appendingPathComponent("\("Earning Call Transcript".localized()) \(company.symbol).txt")

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

extension EarningCallTranscriptViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earningCallTranscript == nil ? 0 : 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCallTranscriptCell", for: indexPath) as! EarningCallTranscriptCell

        cell.earningCallTranscript = earningCallTranscript

        return cell
    }
}
