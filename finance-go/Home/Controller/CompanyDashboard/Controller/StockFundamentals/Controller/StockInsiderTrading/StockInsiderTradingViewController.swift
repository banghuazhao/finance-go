//
//  StockInsiderTradingViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 11/21/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import MJRefresh
import Sheeeeeeeeet
import UIKit

class StockInsiderTradingViewController: FGUIViewController {
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
    var sortIndex: Int = 0

    var stockInsiderTradings = [StockInsiderTrading]()

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(StockInsiderTradingCell.self, forCellReuseIdentifier: "StockInsiderTradingCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()
        
        title = "Stock Insider Trading".localized()

        let shareItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        let sortItem = UIBarButtonItem(image: UIImage(named: "navItem_sort"), style: .plain, target: self, action: #selector(sort(_:)))

        navigationItem.rightBarButtonItems = [shareItem, sortItem]

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()

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
    }
}

// MARK: - methods

extension StockInsiderTradingViewController {
    @objc func fetchDataOnline() {
        guard let company = company else { return }
        startFetchData()
        let urlString = APIManager.baseURL + "/api/v4/insider-trading"
        
        let parameters = [
            "symbol": company.symbol,
            "apikey": Constants.APIKey,
        ]

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(12 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { return }
                    guard let financialDicts = json as? [[String: Any]] else { return }
                    print(financialDicts)
                    var temp = [StockInsiderTrading]()

                    for financialDict in financialDicts {
                        let holderProfile = StockInsiderTrading(
                            symbol: financialDict["symbol"] as? String ?? "No Data".localized(),
                            transactionDate: financialDict["transactionDate"] as? String ?? "No Data".localized(),
                            reportingCik: financialDict["reportingCik"] as? String ?? "No Data".localized(),
                            transactionType: financialDict["transactionType"] as? String ?? "No Data".localized(),
                            securitiesOwned: financialDict["securitiesOwned"] as? Double,
                            companyCik: financialDict["companyCik"] as? String ?? "No Data".localized(),
                            reportingName: financialDict["reportingName"] as? String ?? "No Data".localized(),
                            typeOfOwner: financialDict["typeOfOwner"] as? String ?? "No Data".localized(),
                            acquistionOrDisposition: financialDict["acquistionOrDisposition"] as? String ?? "No Data".localized(),
                            formType: financialDict["formType"] as? String ?? "No Data".localized(),
                            securitiesTransacted: financialDict["securitiesTransacted"] as? Double,
                            securityName: financialDict["securityName"] as? String ?? "No Data".localized(),
                            link: financialDict["link"] as? String ?? "No Data".localized())
                        temp.append(holderProfile)
                    }

                    temp.sort { Date.convertStringyyyyMMddToDate(string: $0.transactionDate) ?? Date() > Date.convertStringyyyyMMddToDate(string: $1.transactionDate) ?? Date() }

                    var stockInsiderTradingsTemp = [StockInsiderTrading]()
                    for stockInsiderTrading in temp {
                        stockInsiderTradingsTemp.append(stockInsiderTrading)
                    }
                    self.stockInsiderTradings = stockInsiderTradingsTemp
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.stockInsiderTradings.count == 0 {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.stockInsiderTradings.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

// MARK: - actions

extension StockInsiderTradingViewController {
    @objc func sort(_ sender: UIBarButtonItem) {
        let itemTitles = [
            "By Date".localized(),
            "By Securities Transacted".localized(),
        ]

        var items: [MenuItem] = []
        for (i, itemTitle) in itemTitles.enumerated() {
            let item = SingleSelectItem(title: itemTitle, isSelected: i == sortIndex, image: nil)
            items.append(item)
        }

        let cancelButton = CancelButton(title: "Cancel".localized())
        items.append(cancelButton)
        let menu = Menu(title: "Sort".localized(), items: items)

        let sheet = menu.toActionSheet { [weak self] _, item in
            guard let self = self else { return }
            guard item.title != "Cancel".localized() && item.title != "Sort".localized() else { return }

            let title = item.title
            self.sortIndex = itemTitles.firstIndex(of: title)!

            guard self.stockInsiderTradings.count > 1 else { return }

            if self.sortIndex == 0 {
                self.stockInsiderTradings.sort { Date.convertStringyyyyMMddToDate(string: $0.transactionDate) ?? Date() > Date.convertStringyyyyMMddToDate(string: $1.transactionDate) ?? Date() }
            } else {
                self.stockInsiderTradings.sort { $0.securitiesTransacted ?? 0 > $1.securitiesTransacted ?? 0 }
            }
            self.tableView.reloadData()
        }

        sheet.present(in: self, from: sender)
    }

    @objc func share(_ sender: UIBarButtonItem) {
        guard let company = company else { return }

        var str: String = ""

        str += "\("Company".localized()):\t\(company.name) (\(company.symbol))\n"

        str += "\n"

        str += "\("Stock Insider Trading".localized()):\n"

        str += "\n"

        for stockInsiderTrading in stockInsiderTradings {
            str += "Transaction Date: \(stockInsiderTrading.transactionDate)\n"
            str += "Reporting CIK: \(stockInsiderTrading.reportingCik)\n"
            str += "Transaction Type: \(stockInsiderTrading.transactionType)\n"
            if let securitiesOwned = stockInsiderTrading.securitiesOwned {
                str += "Securities Owned: \(securitiesOwned)\n"
            } else {
                str += "Securities Owned: \("No Data".localized())\n"
            }
            str += "Company CIK: \(stockInsiderTrading.companyCik)\n"
            str += "Reporting Name: \(stockInsiderTrading.reportingName)\n"
            str += "Type of Owner: \(stockInsiderTrading.typeOfOwner)\n"
            str += "Acquistion or Disposition: \(stockInsiderTrading.acquistionOrDisposition)\n"
            str += "Form Type: \(stockInsiderTrading.formType)\n"
            if let securitiesTransacted = stockInsiderTrading.securitiesTransacted {
                str += "Securities Transacted: \(securitiesTransacted)\n"
            } else {
                str += "Securities Transacted: \("No Data".localized())\n"
            }
            str += "Security Name: \(stockInsiderTrading.securityName)\n"
            str += "Link: \(stockInsiderTrading.link)\n"
            str += "\n"
        }

        let file = getDocumentsDirectory().appendingPathComponent("\("Stock Insider Trading".localized()) \(company.symbol).txt")

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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StockInsiderTradingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockInsiderTradings.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockInsiderTradingCell", for: indexPath) as! StockInsiderTradingCell

        cell.stockInsiderTrading = stockInsiderTradings[indexPath.row]

        return cell
    }
}
