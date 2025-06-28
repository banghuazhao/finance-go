//
//  WatchlistViewController.swift
//  Financial Statements Go
//
//  Created by Lulin Y on 2021/11/7.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
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
import Schedule
import Sheeeeeeeeet
import SnapKit
import SwiftyJSON
import Then
import UIKit

class WatchlistViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        /// The number of native ads to load (must be less than 5).
        let numAdsToLoad = 5

        /// The native ads.
        var nativeAds = [GADNativeAd]()

        /// The ad loader that loads the native ads.
        var adLoader: GADAdLoader!
        var adLoaders: [GADAdLoader]!
    #endif

    var watchCompanies: [Company] = WatchCompanyHelper.getAllWatchCompanies()
    var stockNews = [AnyObject]()

    lazy var tableView = UITableView(frame: .zero, style: .grouped).then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self

        tv.register(SectionTitleHeader.self, forHeaderFooterViewReuseIdentifier: "SectionTitleHeader")
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        
        #if !targetEnvironment(macCatalyst)
            tv.register(NativeNewsAdCell.self, forCellReuseIdentifier: "NativeNewsAdCell")
        #endif
        
        tv.register(StockNewCell.self, forCellReuseIdentifier: "StockNewCell")

        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false

        tv.sectionFooterHeight = 0.0

        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    lazy var noCompanyLabel = UILabel().then { label in

        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 24, height: 24)

        imageAttachment.image = UIImage(named: "icon_star")?.withRenderingMode(.alwaysTemplate).tinted(with: UIColor.lightGray)

        let string1 = NSMutableAttributedString(string: "The watchlist is empty".localized() + "\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])
        let string2 = NSMutableAttributedString(string: "Tap".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])
        let space1 = NSMutableAttributedString(string: "  ")
        let space2 = NSMutableAttributedString(string: "  ")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let string3 = NSMutableAttributedString(string: "to add".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])

        let mutableAttributedString = NSMutableAttributedString()

        mutableAttributedString.append(string1)
        mutableAttributedString.append(string2)
        mutableAttributedString.append(space1)
        mutableAttributedString.append(attachmentString)
        mutableAttributedString.append(space2)
        mutableAttributedString.append(string3)

        label.attributedText = mutableAttributedString
        label.numberOfLines = 2
        label.textAlignment = .center
    }

    var taskFetchQuotes: Task?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskFetchQuotes?.resume()
        watchCompanies = WatchCompanyHelper.getAllWatchCompanies()
        tableView.reloadData()
        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskFetchQuotes?.suspend()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

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

            NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        #endif

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }

        view.addSubview(noCompanyLabel)

        noCompanyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }

        tableView.reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(didAddWatchCompany(_:)), name: .didAddWatchCompany, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveWatchCompany(_:)), name: .didRemoveWatchCompany, object: nil)

        taskFetchQuotes = Plan.after(0.second, repeating: 2.second).do {
            self.fetchQuotes()
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchNewsOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
            tableView.mj_header?.beginRefreshing()
        }
    }
}

// MARK: - actions

extension WatchlistViewController {
    #if !targetEnvironment(macCatalyst)
        @objc func handlePurchaseNotification(_ notification: Notification) {
            nativeAds = []
            stockNews = stockNews.filter { object in
                return object is StockNew
            }
            tableView.reloadData()
        }
    #endif

    @objc func didAddWatchCompany(_ notificaiton: Notification) {
        watchCompanies = WatchCompanyHelper.getAllWatchCompanies()
        tableView.reloadData()
        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }
    }

    @objc func didRemoveWatchCompany(_ notificaiton: Notification) {
        watchCompanies = WatchCompanyHelper.getAllWatchCompanies()
        tableView.reloadData()
        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }
    }
}

// MARK: - methods

extension WatchlistViewController {
    private func fetchQuotes() {
        print(#function)

        guard watchCompanies.count > 0 else { return }

        var fetchCompanies = [Company]()

        if watchCompanies.count < 800 {
            fetchCompanies = watchCompanies
        } else {
            for cellTemp in tableView.visibleCells {
                if let cell = cellTemp as? CompanyCell, let company = cell.company {
                    fetchCompanies.append(company)
                }
            }
        }

        guard fetchCompanies.count > 0 else { return }

        let companySymbols = fetchCompanies.map { $0.symbol }

        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }
        let urlString = "https://financialmodelingprep.com/api/v3/quote/\(quaryPara)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameters = ["apikey": Constants.APIKey]
        AF.request(urlString, parameters: parameters).responseData { response in
            switch response.result {
            case let .success(data):
                print(urlString)
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

    @objc private func fetchNewsOnline() {
        guard watchCompanies.count > 0 else {
            tableView.mj_header?.endRefreshing()
            return
        }

        let companySymbols = watchCompanies.map { $0.symbol }
        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }

        let urlString = APIManager.baseURL + "/api/v3/stock_news"
        let parameters = [
            "tickers": quaryPara,
            "limit": "50",
            "apikey": Constants.APIKey,
        ]
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .seconds(-1),
            fetchType: .online) { [weak self] response in
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
                    self.stockNews = newsTemp
                    self.tableView.mj_header?.endRefreshing()
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if watchCompanies.count == 0 {
            return 1
        } else {
            return stockNews.count > 0 ? 2 : 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return watchCompanies.count > 4 ? 4 : watchCompanies.count
        } else {
            return stockNews.count > 45 ? 45 : stockNews.count
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionTitleHeader") as! SectionTitleHeader
            headerView.titleText = "Watchlist".localized()
            headerView.moreButtonAction = watchCompanies.count <= 4 ? nil : {
                [weak self] in
                guard let self = self else { return }
                let watchCompanyViewController = WatchCompanyViewController()
                watchCompanyViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(watchCompanyViewController, animated: true)
            }
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionTitleHeader") as! SectionTitleHeader
            headerView.titleText = "News".localized()
            headerView.moreButtonAction = stockNews.count <= 45 ? nil : {
                [weak self] in
                guard let self = self else { return }
                let stockNewsViewController = StockNewsViewController()
                stockNewsViewController.hidesBottomBarWhenPushed = true
                stockNewsViewController.companies = self.watchCompanies
                self.navigationController?.pushViewController(stockNewsViewController, animated: true)
            }
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
            cell.company = watchCompanies[indexPath.row]
            return cell
        } else {
            #if !targetEnvironment(macCatalyst)
                if let new = stockNews[indexPath.row] as? StockNew {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
                    cell.stockNew = new
                    cell.hasSeparator = true
                    return cell
                } else {
                    let nativeAd = stockNews[indexPath.row] as! GADNativeAd
                    /// Set the native ad's rootViewController to the current view controller.
                    nativeAd.rootViewController = self

                    let cell = tableView.dequeueReusableCell(withIdentifier: "NativeNewsAdCell", for: indexPath) as! NativeNewsAdCell
                    cell.nativeAd = nativeAd
                    cell.hasSeparator = true
                    return cell
                }
            #else
                let new = stockNews[indexPath.row] as! StockNew
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
                cell.stockNew = new
                cell.hasSeparator = true
                return cell
            #endif
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.hidesBottomBarWhenPushed = true
            companyDashboardViewController.company = watchCompanies[indexPath.row]
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        } else {
            if let new = stockNews[indexPath.row] as? StockNew {
                let stockNewDetailViewController = StockNewDetailViewController()
                stockNewDetailViewController.hidesBottomBarWhenPushed = true
                stockNewDetailViewController.selectedStockNew = new
                navigationController?.pushViewController(stockNewDetailViewController, animated: true)
            }
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension WatchlistViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

#if !targetEnvironment(macCatalyst)

    // MARK: - GADAdLoaderDelegate

    extension WatchlistViewController: GADNativeAdLoaderDelegate {
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
            if nativeAds.count <= 0 || stockNews.count == 0 {
                return
            }
            for (i, nativeAd) in nativeAds.enumerated() {
                let position = 2 + i * 7

                if stockNews.count - 1 >= position {
                    stockNews.insert(nativeAd, at: position)
                }
            }
            tableView.reloadData()
        }
    }
#endif
