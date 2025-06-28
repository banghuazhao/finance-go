//
//  CompanyDashboardViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/16.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Alamofire
import Cache
import DateToolsSwift
import Hue
import Kingfisher
import Localize_Swift
import Schedule
import SnapKit
import SwiftyJSON
import Then
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
    // import GoogleMobileAdsMediationTestSuite
#endif

class CompanyDashboardViewController: FGUIViewController {
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

    var isSelectingStockLine: Bool = false

    private var oneDayStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var oneWeekStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var oneMonthStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var threeMonthStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var oneYearStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var fiveYearStockPrices: [StockChartPrice]? = [StockChartPrice]()
    private var maxStockPrices: [StockChartPrice]? = [StockChartPrice]()

    private var models = [Any?]()

    private var stockNews = [StockNew]()
    private var articles = [Article]()
    private var stockPeers = [Company]()

    private var cellHeights: [IndexPath: CGFloat] = [:]

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self

        tv.register(StockChartPriceCell.self, forCellReuseIdentifier: "StockChartPriceCell")
        tv.register(StockChartPriceSimpleCell.self, forCellReuseIdentifier: "StockChartPriceSimpleCell")

        tv.register(StockFundamentalSectionCell.self, forCellReuseIdentifier: "StockFundamentalSectionCell")

        tv.register(RowTitleHeader.self, forCellReuseIdentifier:
            "RowTitleHeader")
        tv.register(StockNewCell.self, forCellReuseIdentifier: "StockNewCell")
        tv.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")

        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.delaysContentTouches = false
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))

        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    private var taskFetchQuote: Task?
    private var taskFetch5MinuteStock: Task?
    private var taskFetch15MinuteStock: Task?

    deinit {
        print("CompanyDashboardViewController deinit")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskFetchQuote?.resume()
        taskFetch5MinuteStock?.resume()
        taskFetch15MinuteStock?.resume()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        taskFetchQuote?.suspend()
        taskFetch5MinuteStock?.suspend()
        taskFetch15MinuteStock?.suspend()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

//        GoogleMobileAdsMediationTestSuite.present(on: self, delegate: nil)

        models = [company, company]

        title = company?.symbol ?? ""

        if let company = company, [ValueType.stock, ValueType.fund, ValueType.etf].contains(company.type) {
            let infoButton = UIButtonLargerTouchArea(type: .custom).then { b in
                b.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
                b.addTarget(self, action: #selector(companyInfo), for: .touchUpInside)
                b.tintColor = .white1
                b.snp.makeConstraints { make in
                    make.size.equalTo(24)
                }
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
        }

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
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

        taskFetchQuote = Plan.after(0.seconds, repeating: 2.second).do {
            self.fetchCompanyQuote()
        }

        fetchOneDayStock()

        fetchStockNews()

        fetchArticles()

        if let company = company, [ValueType.stock, .etf, .fund].contains(company.type) {
            fetchStockPeers()
        }

        if let company = company, company.isUSCompany || [ValueType.index, .cryptocurrency, .future, .forex].contains(company.type) {
            taskFetch5MinuteStock = Plan.after(0.second, repeating: 2.5.minute).do {
                self.fetch5MinuteStock()
            }

            taskFetch15MinuteStock = Plan.after(0.second, repeating: 7.5.minute).do {
                self.fetch15MinuteStock()
            }
        }
    }
}

// MARK: - actions

extension CompanyDashboardViewController {
    @objc func companyInfo() {
        let comanpyProfileViewController = CompanyProfileViewController()
        comanpyProfileViewController.company = company
        navigationController?.pushViewController(comanpyProfileViewController, animated: true)
    }
}

// MARK: - methods

extension CompanyDashboardViewController {
    private func fetchCompanyQuote() {
        print(#function)
        guard let symbol = company?.symbol else { return }
        let urlString = (APIManager.baseURL + "/api/v3/quote/\(symbol)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .seconds(2),
            fetchType: .online) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                if let json = JSON(data).arrayValue.first {
                    self.company?.companyQuote = CompanyQuote(json: json)
                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetch5MinuteStock() {
        print(#function)
        guard let symbol = company?.symbol else { return }
        let urlString = (APIManager.baseURL + "/api/v3/historical-chart/5min/\(symbol)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .seconds(2.5 * 60),
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                let jsons = JSON(data)
                var temp = [StockChartPrice]()
                for json in jsons.arrayValue {
                    temp.append(StockChartPrice(json: json))
                }
                self.oneDayStockPrices = self.findDayMinuteStockPrice(stockChartPrices: temp)
                if !self.isSelectingStockLine {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetch15MinuteStock() {
        print(#function)
        guard let symbol = company?.symbol else { return }
        let urlString = (APIManager.baseURL + "/api/v3/historical-chart/15min/\(symbol)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .seconds(7.5 * 60),
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background(qos: .userInteractive) {
                    let jsons = JSON(data)
                    var temp = [StockChartPrice]()
                    for json in jsons.arrayValue {
                        temp.append(StockChartPrice(json: json))
                    }
                    self.oneWeekStockPrices = self.findOneWeekStockPrice(stockChartPrices: temp)
                } completion: {
                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetchOneDayStock() {
        guard let symbol = company?.symbol else { return }
        let urlString = (APIManager.baseURL + "/api/v3/historical-price-full/\(symbol)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameters = ["serietype": "line", "apikey": Constants.APIKey]
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(12 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let jsons = JSON(data)["historical"]
                    var temp = [StockChartPrice]()
                    for json in jsons.arrayValue {
                        temp.append(StockChartPrice(jsonDaily: json))
                    }
                    self.oneMonthStockPrices = self.findOneMonthStockPrice(stockChartPrices: temp)
                    self.threeMonthStockPrices = self.findThreeMonthStockPrice(stockChartPrices: temp)
                    self.oneYearStockPrices = self.findOneYearStockPrice(stockChartPrices: temp)
                    self.fiveYearStockPrices = self.findFiveYearStockPrice(stockChartPrices: temp)
                    self.maxStockPrices = self.findMaxStockPrice(stockChartPrices: temp)
                } completion: {
                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetchStockNews() {
        guard let company = company else { return }
        let urlString = (APIManager.baseURL + "/api/v3/stock_news").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if [ValueType.stock, .etf, .fund].contains(company.type) {
            // 公司使用tickers参数找
            let parameters = ["tickers": company.symbol, "limit": "5", "apikey": Constants.APIKey]
            NetworkManager.shared.request(
                urlString: urlString,
                parameters: parameters,
                cacheExpire: .seconds(10 * 60),
                fetchType: .cacheOrOnline) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    let json = JSON(data)
                    var newsTemp = [StockNew]()
                    for value in json.arrayValue {
                        newsTemp.append(StockNew(json: value))
                    }
                    self.stockNews = newsTemp

                    var tempModels = [Any]()

                    if newsTemp.count > 0 {
                        tempModels.append("News")
                        if newsTemp.count > 3 {
                            tempModels.append(contentsOf: Array(newsTemp[0 ... 2]))
                        } else {
                            tempModels.append(contentsOf: newsTemp)
                        }
                    }

                    self.models.insert(contentsOf: tempModels, at: 2)

                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    print("\(String(describing: type(of: self))) Network error:", error)
                }
            }
        } else if company.type == .cryptocurrency || company.type == .forex {
            let companyType: String
            if company.type == .cryptocurrency {
                companyType = "crypto_news"
            } else {
                companyType = "forex_news"
            }
            let urlStringNew = (APIManager.baseURL + "/api/v4/\(companyType)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let parameters = ["symbol": company.symbol, "apikey": Constants.APIKey]
            NetworkManager.shared.request(
                urlString: urlStringNew,
                parameters: parameters,
                cacheExpire: .seconds(10 * 60),
                fetchType: .cacheOrOnline) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    let json = JSON(data)
                    var newsTemp = [StockNew]()
                    for value in json.arrayValue {
                        newsTemp.append(StockNew(json: value))
                    }
                    self.stockNews = newsTemp

                    var tempModels = [Any]()

                    if newsTemp.count > 0 {
                        tempModels.append("News")
                        if newsTemp.count > 3 {
                            tempModels.append(contentsOf: Array(newsTemp[0 ... 2]))
                        } else {
                            tempModels.append(contentsOf: newsTemp)
                        }
                    }

                    self.models.insert(contentsOf: tempModels, at: 2)

                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    print("\(String(describing: type(of: self))) Network error:", error)
                }
            }
        } else {
            // index, future, cryptocurrency: symbol, 前两位名称完全匹配
            NetworkManager.shared.request(
                urlString: urlString,
                parameters: APIManager.singleAPIKeyParameter,
                cacheExpire: .seconds(10 * 60),
                fetchType: .cacheOrOnline) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    let json = JSON(data)
                    var newsTemp = [StockNew]()
                    for value in json.arrayValue {
                        newsTemp.append(StockNew(json: value))
                    }

                    let keywordArray = company.name.split(separator: " ")
                    let keyword1 = String(keywordArray[0]).lowercased()
                    var keyword2 = keyword1
                    if keywordArray.count > 1 {
                        keyword2 = keyword1 + " " + String(keywordArray[1]).lowercased()
                    }

                    newsTemp = newsTemp.filter({ new in
                        new.title.contains(word: company.symbol) ||
                            new.title.lowercased().contains(word: keyword1) ||
                            new.title.lowercased().contains(word: keyword2) ||
                            new.text.contains(word: company.symbol) ||
                            new.text.lowercased().contains(word: keyword1) ||
                            new.text.lowercased().contains(word: keyword2)
                    })

                    self.stockNews = newsTemp

                    var tempModels = [Any]()

                    if newsTemp.count > 0 {
                        tempModels.append("News")
                        if newsTemp.count > 3 {
                            tempModels.append(contentsOf: Array(newsTemp[0 ... 2]))
                        } else {
                            tempModels.append(contentsOf: newsTemp)
                        }
                    }

                    self.models.insert(contentsOf: tempModels, at: 2)

                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                case let .failure(error):
                    print("\(String(describing: type(of: self))) Network error:", error)
                }
            }
        }
    }

    private func fetchArticles() {
        guard let company = company else { return }
        let urlString = APIManager.baseURL + "/api/v4/articles"
        let parameters = ["size": "300", "apikey": Constants.APIKey]
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(8 * 60 * 60)),
            fetchType: .cacheOrOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var articlesTemp = [Article]()
                    for value in json["content"].arrayValue {
                        articlesTemp.append(Article(json: value))
                    }

                    if [ValueType.index, .future, .cryptocurrency, .forex].contains(company.type) {
                        // index, future, cryptocurrency: symbol, 前两位名称完全匹配

                        let keywordArray = company.name.split(separator: " ")
                        let keyword1 = String(keywordArray[0]).lowercased()
                        var keyword2 = keyword1
                        if keywordArray.count > 1 {
                            keyword2 = keyword1 + " " + String(keywordArray[1]).lowercased()
                        }
                        articlesTemp = articlesTemp.filter({ new in
                            let splits = new.tickers.components(separatedBy: ":")
                            return splits.contains(company.symbol) ||
                                new.title.contains(word: company.symbol) ||
                                new.title.lowercased().contains(word: keyword1) ||
                                new.title.lowercased().contains(word: keyword2) ||
                                new.content.contains(word: company.symbol) ||
                                new.content.lowercased().contains(word: keyword1) ||
                                new.content.lowercased().contains(word: keyword2)
                        })
                    } else {
                        // 公司symbol完全匹配
                        articlesTemp = articlesTemp.filter({ new in
                            let splits = new.tickers.components(separatedBy: ":")
                            return splits.contains(company.symbol)
                        })
                    }

                    self.articles = articlesTemp

                    var tempModels = [Any]()

                    if articlesTemp.count > 0 {
                        tempModels.append("Articles")
                        if articlesTemp.count > 3 {
                            tempModels.append(contentsOf: Array(articlesTemp[0 ... 2]))
                        } else {
                            tempModels.append(contentsOf: articlesTemp)
                        }
                    }

                    if let index = self.models.firstIndex(where: { model in
                        if let title = model as? String, title == "Stock Peers" {
                            return true
                        }
                        return false
                    }) {
                        self.models.insert(contentsOf: tempModels, at: index)
                    } else {
                        self.models.append(contentsOf: tempModels)
                    }

                } completion: {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetchStockPeers() {
        guard let symbol = company?.symbol else { return }
        let urlString = (APIManager.baseURL + "/api/v4/stock_peers").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameters = ["symbol": symbol, "apikey": Constants.APIKey]
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(24 * 60 * 60)),
            fetchType: .cacheOrOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                guard let json = JSON(data).arrayValue.first else { return }
                let peerList = json["peersList"].arrayValue
                var tempCompanies = [Company]()
                for peer in peerList {
                    let symbol = peer.stringValue
                    if let companyTemp = CompanyStore.shared.item(symbol: symbol) {
                        tempCompanies.append(companyTemp)
                    }
                }
                self.stockPeers = tempCompanies

                var tempModels = [Any]()
                if tempCompanies.count > 3 {
                    tempModels.append("Stock Peers")
                    tempModels.append(contentsOf: Array(tempCompanies[0 ... 2]))
                } else {
                    tempModels.append(contentsOf: tempCompanies)
                }

                self.models.append(contentsOf: tempModels)

                if !self.isSelectingStockLine {
                    self.tableView.reloadData()
                    self.fetchStockPeersQuote(stockPeers: self.stockPeers)
                }

            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    private func fetchStockPeersQuote(stockPeers: [Company]) {
        guard stockPeers.count > 0 else { return }
        let companySymbols = stockPeers.map { $0.symbol }
        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }
        let urlString = APIManager.baseURL + "/api/v3/quote/\(quaryPara)"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(-1)),
            fetchType: .online) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    for value in json.arrayValue {
                        if let symbol = value["symbol"].string {
                            CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
                        }
                    }
                } completion: {
                    if !self.isSelectingStockLine {
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    // MARK: - findDayMinuteStockPrice

    func findDayMinuteStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
        let firstDateString = stockChartPrices[0].date
        let firstDate = Date.convertStringyyyyMMddHHmmssToDate(string: firstDateString) ?? Date()

        var temp = [StockChartPrice]()
        for stockChartPrice in stockChartPrices {
            if temp.count == 0 {
                temp.append(stockChartPrice)
            } else {
                let date = Date.convertStringyyyyMMddHHmmssToDate(string: stockChartPrice.date) ?? Date()
                if firstDate.isSameDay(date: date) {
                    temp.append(stockChartPrice)
                } else {
                    break
                }
            }
        }
        temp.reverse()
        return temp
    }

    func findOneWeekStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
        let firstDateString = stockChartPrices[0].date
        let firstDate = Date.convertStringyyyyMMddHHmmssToDate(string: firstDateString) ?? Date()

        var temp = [StockChartPrice]()
        for stockChartPrice in stockChartPrices {
            if temp.count == 0 {
                temp.append(stockChartPrice)
            } else {
                let date = Date.convertStringyyyyMMddHHmmssToDate(string: stockChartPrice.date) ?? Date()
                let diff = firstDate.weeks(from: date)
                if diff < 1 {
                    temp.append(stockChartPrice)
                } else {
                    break
                }
            }
        }
        temp.reverse()
        return temp
    }

    func findOneMonthStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
        let firstDateString = stockChartPrices[0].date
        let firstDate = Date.convertStringyyyyMMddToDate(string: firstDateString) ?? Date()

        var temp = [StockChartPrice]()
        for stockChartPrice in stockChartPrices {
            if temp.count == 0 {
                temp.append(stockChartPrice)
            } else {
                let date = Date.convertStringyyyyMMddToDate(string: stockChartPrice.date) ?? Date()
                let diff = firstDate.months(from: date)
                if diff < 1 {
                    temp.append(stockChartPrice)
                } else {
                    break
                }
            }
        }
        temp.reverse()
        return temp
    }

    func findThreeMonthStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
        let firstDateString = stockChartPrices[0].date
        let firstDate = Date.convertStringyyyyMMddToDate(string: firstDateString) ?? Date()

        var temp = [StockChartPrice]()
        for stockChartPrice in stockChartPrices {
            let date = Date.convertStringyyyyMMddToDate(string: stockChartPrice.date) ?? Date()
            let diff = firstDate.months(from: date)
            if diff < 3 {
                temp.append(stockChartPrice)
            } else {
                break
            }
        }
        temp.reverse()
        return temp
    }

    func findOneYearStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
        let firstDateString = stockChartPrices[0].date
        let firstDate = Date.convertStringyyyyMMddToDate(string: firstDateString) ?? Date()

        var temp = [StockChartPrice]()
        for stockChartPrice in stockChartPrices {
            let date = Date.convertStringyyyyMMddToDate(string: stockChartPrice.date) ?? Date()
            let diff = firstDate.years(from: date)
            if diff < 1 {
                temp.append(stockChartPrice)
            } else {
                break
            }
        }
        temp.reverse()
        return temp
    }

    func findFiveYearStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        var temp = [StockChartPrice]()
        if stockChartPrices.count < 260 {
            for stockChartPrice in stockChartPrices {
                temp.append(stockChartPrice)
            }
        } else {
            guard stockChartPrices.count > 0 else { return [StockChartPrice]() }
            let firstDateString = stockChartPrices[0].date
            let firstDate = Date.convertStringyyyyMMddToDate(string: firstDateString) ?? Date()
            for (i, stockChartPrice) in stockChartPrices.enumerated() {
                if i % 7 == 0 {
                    let date = Date.convertStringyyyyMMddToDate(string: stockChartPrice.date) ?? Date()
                    let diff = firstDate.years(from: date)
                    if diff < 5 {
                        temp.append(stockChartPrice)
                    } else {
                        break
                    }
                }
            }
        }
        temp.reverse()
        return temp
    }

    func findMaxStockPrice(stockChartPrices: [StockChartPrice]) -> [StockChartPrice] {
        var temp = [StockChartPrice]()
        if stockChartPrices.count < 300 {
            return stockChartPrices.reversed()
        } else {
            for (i, stockChartPrice) in stockChartPrices.enumerated() {
                let denominator = stockChartPrices.count / 300
                if i % denominator == 0 {
                    temp.append(stockChartPrice)
                }
            }
            if temp[temp.count - 1].date != stockChartPrices[stockChartPrices.count - 1].date {
                temp.append(stockChartPrices[stockChartPrices.count - 1])
            }
            temp.reverse()
            return temp
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDelegate

extension CompanyDashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        if indexPath.row == 0 {
            if let company = company, company.isUSCompany || [ValueType.index, .cryptocurrency, .future, .forex].contains(company.type) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockChartPriceCell", for: indexPath) as! StockChartPriceCell
                cell.company = company
                cell.oneDayStockPrices = oneDayStockPrices
                cell.oneWeekStockPrices = oneWeekStockPrices
                cell.oneMonthStockPrices = oneMonthStockPrices
                cell.threeMonthStockPrices = threeMonthStockPrices
                cell.oneYearStockPrices = oneYearStockPrices
                cell.fiveYearStockPrices = fiveYearStockPrices
                cell.maxStockPrices = maxStockPrices
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockChartPriceSimpleCell", for: indexPath) as! StockChartPriceSimpleCell
                cell.company = company
                cell.oneMonthStockPrices = oneMonthStockPrices
                cell.threeMonthStockPrices = threeMonthStockPrices
                cell.oneYearStockPrices = oneYearStockPrices
                cell.fiveYearStockPrices = fiveYearStockPrices
                cell.maxStockPrices = maxStockPrices
                return cell
            }
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockFundamentalSectionCell", for: indexPath) as! StockFundamentalSectionCell
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.company = company
            return cell

        } else if let data = model as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RowTitleHeader", for: indexPath) as! RowTitleHeader
            cell.titleText = data.localized()
            if data == "News" {
                guard let company = self.company else { return cell }
                if [ValueType.stock, .etf, .fund].contains(company.type) {
                    cell.moreButtonAction = stockNews.count <= 3 ? nil : { [weak self] in
                        guard let self = self else { return }
                        let stockNewsViewController = StockNewsViewController()
                        stockNewsViewController.companies = [company]
                        self.navigationController?.pushViewController(stockNewsViewController, animated: true)
                    }
                } else {
                    cell.moreButtonAction = stockNews.count <= 3 ? nil : { [weak self] in
                        guard let self = self else { return }
                        let ctockNewsStaticViewController = StockNewsStaticViewController()
                        ctockNewsStaticViewController.news = self.stockNews
                        self.navigationController?.pushViewController(ctockNewsStaticViewController, animated: true)
                    }
                }
            } else if data == "Articles" {
                cell.moreButtonAction = articles.count <= 3 ? nil : { [weak self] in
                    guard let self = self else { return }
                    let articleStaticViewController = ArticleStaticViewController()
                    articleStaticViewController.news = self.articles
                    self.navigationController?.pushViewController(articleStaticViewController, animated: true)
                }
            } else {
                cell.moreButtonAction = stockPeers.count <= 3 ? nil : { [weak self] in
                    guard let self = self else { return }
                    let stockPeersViewController = StockPeersViewController()
                    stockPeersViewController.stockPeers = self.stockPeers
                    self.navigationController?.pushViewController(stockPeersViewController, animated: true)
                }
            }
            return cell
        } else if let data = model as? StockNew {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockNewCell", for: indexPath) as! StockNewCell
            cell.stockNew = data
            cell.hasSeparator = true
            return cell
        } else if let data = model as? Article {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
            cell.article = data
            cell.hasSeparator = true
            return cell
        } else if let data = model as? Company {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
            cell.company = data
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is StockNewCell, let data = models[indexPath.row] as? StockNew {
            if let company = company {
                if company.type == .cryptocurrency {
                    let vc = OtherNewsDetailViewController()
                    vc.newsType = "crypto_news"
                    vc.selectedStockNew = data
                    navigationController?.pushViewController(vc, animated: true)
                } else if company.type == .forex {
                    let vc = OtherNewsDetailViewController()
                    vc.newsType = "forex_news"
                    vc.selectedStockNew = data
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = StockNewDetailViewController()
                    vc.selectedStockNew = data
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        if tableView.cellForRow(at: indexPath) is ArticleCell, let data = models[indexPath.row] as? Article {
            let articleDetailViewController = ArticleDetailViewController()
            articleDetailViewController.selectedArticle = data
            navigationController?.pushViewController(articleDetailViewController, animated: true)
        }

        if tableView.cellForRow(at: indexPath) is CompanyCell, let data = models[indexPath.row] as? Company {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = data
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }
}
