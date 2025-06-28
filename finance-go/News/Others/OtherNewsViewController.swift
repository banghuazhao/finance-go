//
//  OtherNewsViewController.swift
//  Financial Statements Go
//
//  Created by Lulin Y on 2022/9/11.
//  Copyright © 2022 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import JXSegmentedView
import Localize_Swift
import MJRefresh
import SnapKit
import SwiftyJSON
import Then
import UIKit

class OtherNewsViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        /// The number of native ads to load (must be less than 5).
        let numAdsToLoad = 5

        /// The native ads.
        var nativeAds = [GADNativeAd]()

        /// The ad loader that loads the native ads.
        var adLoader: GADAdLoader!
        var adLoaders: [GADAdLoader]!
    #endif

    var company: Company?

    var newsType = "crypto_news"

    var news: [AnyObject] = []

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(StockNewCell.self, forCellReuseIdentifier: "StockNewCell")
        #if !targetEnvironment(macCatalyst)
            tv.register(NativeNewsAdCell.self, forCellReuseIdentifier: "NativeNewsAdCell")
        #endif
        tv.separatorColor = UIColor.white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
        }
    }

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                let options = GADMultipleAdsAdLoaderOptions()
                options.numberOfAds = numAdsToLoad

                // Prepare the ad loader and start loading ads.
                adLoader = GADAdLoader(adUnitID: Constants.GoogleAdsID.nativeAdID,
                                       rootViewController: self,
                                       adTypes: [.native],
                                       options: [options])

                adLoader.delegate = self
                adLoader.load(GADRequest())
            }
        #endif

        if newsType == "crypto_news" {
            title = "Crypto News".localized()
        } else {
            title = "Forex News".localized()
        }

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        #if !targetEnvironment(macCatalyst)
            NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        #endif

        tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - actions

extension OtherNewsViewController {
    #if !targetEnvironment(macCatalyst)
        @objc func handlePurchaseNotification(_ notification: Notification) {
            nativeAds = []
            news = news.filter { object in
                object is StockNew
            }
            tableView.reloadData()
        }
    #endif
}

// MARK: - methods

extension OtherNewsViewController {
    @objc private func fetchDataOnline() {
        startFetchData()
        let urlString = APIManager.baseURL + "/api/v4/\(newsType)"
        var parameters = [String: String]()
        let cacheExpire = Expiry.seconds(30 * 60)

        if let company = company {
            parameters = ["symbol": company.symbol, "apikey": Constants.APIKey]
        } else {
            parameters = ["apikey": Constants.APIKey]
        }

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: cacheExpire,
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var newsTemp = [AnyObject]()
                    for value in json.arrayValue {
                        newsTemp.append(StockNew(json: value))
                    }
                    #if !targetEnvironment(macCatalyst)
                        if self.nativeAds.count > 0 {
                            for (i, nativeAd) in self.nativeAds.enumerated() {
                                let position = 2 + i * 7
                                if newsTemp.count - 1 >= position {
                                    newsTemp.insert(nativeAd, at: position)
                                }
                            }
                        }
                    #endif
                    self.news = newsTemp
                } completion: {
                    self.tableView.reloadData()
                    if !response.isCache {
                        self.tableView.mj_header?.endRefreshing()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.news.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension OtherNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #if !targetEnvironment(macCatalyst)
            if let new = news[indexPath.row] as? StockNew {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
                cell.stockNew = new
                return cell
            } else {
                let nativeAd = news[indexPath.row] as! GADNativeAd
                /// Set the native ad's rootViewController to the current view controller.
                nativeAd.rootViewController = self

                let cell = tableView.dequeueReusableCell(withIdentifier: "NativeNewsAdCell", for: indexPath) as! NativeNewsAdCell
                cell.nativeAd = nativeAd
                return cell
            }
        #else
            let new = news[indexPath.row] as! StockNew
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
            cell.stockNew = new
            return cell
        #endif
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let new = news[indexPath.row] as? StockNew {
            let vc = OtherNewsDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.newsType = newsType
            vc.selectedStockNew = new
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

#if !targetEnvironment(macCatalyst)

    // MARK: - GADAdLoaderDelegate

    extension OtherNewsViewController: GADNativeAdLoaderDelegate {
        func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
            print("\(adLoader) failed with error: \(error.localizedDescription)")
            print("error.code: \(error)")
        }

        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            print("Received native ad: \(nativeAd)")

            // Add the native ad to the list of native ads.
            nativeAds.append(nativeAd)
        }

        func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
            if nativeAds.count <= 0 || news.count == 0 {
                return
            }
            for (i, nativeAd) in nativeAds.enumerated() {
                let position = 2 + i * 7

                if news.count - 1 >= position {
                    news.insert(nativeAd, at: position)
                }
            }
            tableView.reloadData()
        }
    }
#endif

// MARK: - JXSegmentedListContainerViewListDelegate

extension OtherNewsViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
