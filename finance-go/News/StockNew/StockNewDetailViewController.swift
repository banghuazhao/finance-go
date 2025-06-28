//
//  StockNewDetailViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/2.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Cache
import UIKit
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import SwiftyJSON

class StockNewDetailViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        /// The number of native ads to load (must be less than 5).
        let numAdsToLoad = 1

        /// The native ads.
        var nativeAds = [GADNativeAd]()

        /// The ad loader that loads the native ads.
        var adLoader: GADAdLoader!
    #endif

    var dataSource = [Any]()
    
    var selectedStockNew: StockNew? {
        didSet {
            guard let selectedStockNew = selectedStockNew else { return }
            title = "Stock News".localized() + ": " + selectedStockNew.symbol
            dataSource.append(selectedStockNew)
            if let company = CompanyStore.shared.item(symbol: selectedStockNew.symbol) {
                dataSource.append("Related Company")
                dataSource.append(company)
            }
            tableView.reloadData()
        }
    }

    var randomNews = [StockNew]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(StockNewDetailCell.self, forCellReuseIdentifier: "StockNewDetailCell")
        tv.register(RowTitleHeader.self, forCellReuseIdentifier: "RowTitleHeader")
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.register(StockNewCell.self, forCellReuseIdentifier: "StockNewCell")
        #if !targetEnvironment(macCatalyst)
            tv.register(NativeNewsAdCell.self, forCellReuseIdentifier: "NativeNewsAdCell")
        #endif
        tv.separatorColor = UIColor.white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
        // Do any additional setup after loading the view.

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

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

        fetchNewsOnline()

        if let selectedStockNew = selectedStockNew, CompanyStore.shared.item(symbol: selectedStockNew.symbol) != nil {
            fetchCompanyQuote()
        }
    }
}

// MARK: - methods

extension StockNewDetailViewController {
    @objc private func fetchNewsOnline() {
        guard let companySymbol = selectedStockNew?.symbol else { return }
        let urlString = APIManager.baseURL + "/api/v3/stock_news"
        let parameters = ["tickers": companySymbol, "apikey": Constants.APIKey]
        NetworkManager.shared.request(urlString: urlString, parameters: parameters, cacheExpire: .seconds(10 * 60), fetchType: .cacheOrOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var news = [StockNew]()
                    for value in json.arrayValue where news.count < 60 {
                        let new = StockNew(json: value)
                        if new.title == self.selectedStockNew?.title { continue }
                        news.append(new)
                    }

                    var randomNews = Array(news.choose(6))

                    guard randomNews.count > 0 else { return }

                    randomNews.sort { new1, new2 in
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        guard let date1 = dateFormater.date(from: new1.date), let date2 = dateFormater.date(from: new2.date) else { return true }
                        return date1 > date2
                    }

                    self.randomNews = randomNews

                    var tempMoreDataSource = [Any]()
                    tempMoreDataSource.append("Related Stock News")
                    tempMoreDataSource.append(contentsOf: randomNews)
                    #if !targetEnvironment(macCatalyst)
                        if self.nativeAds.count > 0 && randomNews.count > 0 {
                            tempMoreDataSource.insert(self.nativeAds[0], at: tempMoreDataSource.count - 1 - randomNews.count / 2)
                        }
                    #endif
                    self.dataSource.append(contentsOf: tempMoreDataSource)
                } completion: {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    func fetchCompanyQuote() {
        guard let symbol = selectedStockNew?.symbol else { return }
        let urlString = APIManager.baseURL + "/api/v3/quote/\(symbol)"
        NetworkManager.shared.request(urlString: urlString, parameters: APIManager.singleAPIKeyParameter, cacheExpire: .seconds(3), fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                for value in json.arrayValue {
                    if let symbol = value["symbol"].string {
                        CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
                    }
                }
                self.tableView.reloadData()
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StockNewDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        if let object = data as? StockNew, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewDetailCell", for: indexPath) as! StockNewDetailCell
            cell.stockNew = object
            return cell
        } else if let object = data as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RowTitleHeader", for: indexPath) as! RowTitleHeader
            cell.titleText = object
            if object == "Related Stock News" {
                cell.moreButtonAction = { [weak self] in
                    guard let self = self else { return }
                    let stockNewsViewController = StockNewsViewController()
                    if let symbol = self.selectedStockNew?.symbol, let company = CompanyStore.shared.item(symbol: symbol) {
                        stockNewsViewController.companies = [company]
                    }
                    self.navigationController?.pushViewController(stockNewsViewController, animated: true)
                }
            } else {
                cell.moreButtonAction = nil
            }
            return cell
        } else if let object = data as? Company {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
            cell.company = object
            return cell
        } else if let object = data as? StockNew, indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
            cell.stockNew = object
            return cell
        }

        #if !targetEnvironment(macCatalyst)
            if let nativeAd = data as? GADNativeAd {
                nativeAd.rootViewController = self
                let cell = tableView.dequeueReusableCell(withIdentifier: "NativeNewsAdCell", for: indexPath) as! NativeNewsAdCell
                cell.nativeAd = nativeAd
                return cell
            }
        #endif

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        if let object = data as? Company {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.hidesBottomBarWhenPushed = true
            companyDashboardViewController.company = object
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        } else if let object = data as? StockNew, indexPath.row != 0 {
            let stockNewDetailViewController = StockNewDetailViewController()
            stockNewDetailViewController.selectedStockNew = object
            navigationController?.pushViewController(stockNewDetailViewController, animated: true)
        }
    }
}

// MARK: - actions

extension StockNewDetailViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        guard let selectedStockNew = selectedStockNew else { return }

        let textToShare = selectedStockNew.title

        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! StockNewDetailCell

        let image = cell.newImageView.image ?? UIImage(named: "select_photo_empty")!

        let url = URL(string: selectedStockNew.url)!

        // Enter link to your app here
        let objectsToShare = [textToShare, url, image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

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

#if !targetEnvironment(macCatalyst)

    // MARK: - GADAdLoaderDelegate

    extension StockNewDetailViewController: GADNativeAdLoaderDelegate {
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
            if nativeAds.count <= 0 || randomNews.count == 0 {
                return
            }
            if nativeAds.count > 0 && randomNews.count > 0 {
                dataSource.insert(nativeAds[0], at: dataSource.count - 1 - randomNews.count / 2)
            }
            tableView.reloadData()
        }
    }
#endif
