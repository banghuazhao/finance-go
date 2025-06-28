//
//  Company.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/23/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class Company: Value {
    var name: String
    let symbol: String
    var type: ValueType

    var price: Double?
    var changesPercentage: Double?

    var exchange: String
    var exchangeShortName: String

    var isWatched: Bool {
        if WatchCompanyHelper.getAllWatchCompanySymbols().contains(symbol) {
            return true
        } else {
            return false
        }
    }

    var companyQuote: CompanyQuote? {
        didSet {
            guard let companyQuote = companyQuote else { return }
            price = companyQuote.price
            changesPercentage = companyQuote.changesPercentage
        }
    }

    var isUSCompany: Bool {
        ["Nasdaq Global Select", "Nasdaq Capital Market", "Nasdaq Global Market", "NASDAQ Global Market", "NASDAQ", "Nasdaq", "NasdaqGM", "NasdaqGS", "New York Stock Exchange", "New York Stock Exchange Arca", "NYSE American", "Other OTC"].contains(exchange)
    }

    var localeIdentifier: String {
        if ["Nasdaq Global Select", "Nasdaq Capital Market", "Nasdaq Global Market", "NASDAQ Global Market", "NASDAQ", "Nasdaq", "NasdaqGM", "NasdaqGS", "New York Stock Exchange", "New York Stock Exchange Arca", "NYSE American"].contains(exchange) {
            return "en_US"
        } else if ["Shanghai", "Shenzhen"].contains(exchange) {
            return "zh_Hans_CN"
        } else if ["Taipei Exchange", "Taiwan"].contains(exchange) {
            return "zh_Hant_TW"
        } else if ["HKSE", "HKG"].contains(exchange) {
            return "zh_Hant_HK"
        } else if ["Tokyo"].contains(exchange) {
            return "ja_JP"
        } else if ["LSE"].contains(exchange) {
            return "en_GB"
        } else if ["Paris"].contains(exchange) {
            return "fr_FR"
        } else if ["Berlin"].contains(exchange) {
            return "de_CH"
        } else if ["Toronto", "Canadian Sec"].contains(exchange) {
            return "en_CA"
        } else {
            return "en_US"
        }
    }

    init(json: JSON) {
        name = json["name"].stringValue
        symbol = json["symbol"].stringValue
        price = json["price"].double
        exchange = json["exchange"].stringValue
        exchangeShortName = json["exchangeShortName"].stringValue

        let typeString = json["type"].stringValue
        if typeString == "fund" {
            type = .fund
        } else if typeString == "etf" {
            type = .etf
        } else {
            type = .stock
        }
    }
}

class CompanyStore {
    static let shared = CompanyStore()

    private var items: [Company] = []

    private var stocks: [Company] = []
    private var etfs: [Company] = []
    private var funds: [Company] = []
    private var majorIndexes: [Company] = []
    private var cryptocurrencies: [Company] = []
    private var futures: [Company] = []
    private var forex: [Company] = []

    private var companySymbols: [String] = []
    private var companySymbolToCompanyMap = [String: Company]()
    private var companyNameToCompanyMap = [String: Company]()
    private init() {}

    private let accessQueue = DispatchQueue(label: "com.financeGo.mySerialQueue", attributes: .concurrent)

    var count: Int {
        return items.count
    }

    func item(index: Int) -> Company? {
        if index < items.count {
            return items[index]
        } else {
            return nil
        }
    }

    func item(symbol: String) -> Company? {
        var returnCompany: Company?
        accessQueue.sync {
            if let company = companySymbolToCompanyMap[symbol] {
                returnCompany = company
            }
        }
        return returnCompany
    }

    func item(companyName: String) -> Company? {
        var returnCompany: Company?
        accessQueue.sync {
            if let company = companyNameToCompanyMap[companyName] {
                returnCompany = company
            }
        }
        return returnCompany
    }

    func add(company: Company) {
        accessQueue.async(flags: .barrier) {
            self.items.append(company)
            if company.type == .stock {
                self.stocks.append(company)
            } else if company.type == .etf {
                self.etfs.append(company)
            } else if company.type == .fund {
                self.funds.append(company)
            }
            self.companySymbolToCompanyMap[company.symbol] = company
            self.companyNameToCompanyMap[company.name] = company
        }
    }

    func companyName(symbol: String) -> String {
        var returnCompanyName = "-"
        accessQueue.sync {
            if let company = companySymbolToCompanyMap[symbol] {
                returnCompanyName = company.name
            }
        }
        return returnCompanyName
    }

    func index(for company: Company) -> Int? {
        items.firstIndex { c in
            c.symbol == company.symbol
        }
    }

    func index(for symbol: String) -> Int? {
        items.firstIndex { c in
            c.symbol == symbol
        }
    }

    func getAll(exchange: String = "All", searchType: ValueType = .all) -> [Company] {
        var temp = items

        if searchType == .stock {
            temp = stocks
        } else if searchType == .fund {
            temp = funds
        } else if searchType == .etf {
            temp = etfs
        } else if searchType == .future {
            temp = futures
        } else if searchType == .cryptocurrency {
            temp = cryptocurrencies
        } else if searchType == .index {
            temp = majorIndexes
        } else if searchType == .forex {
            temp = forex
        }

        if exchange == "All" {
            print("exchange = All")
        } else if exchange == "Nasdaq" {
            temp = temp.filter {
                ["Nasdaq Global Select", "Nasdaq Capital Market", "Nasdaq Global Market", "NASDAQ Global Market", "NASDAQ", "Nasdaq", "NasdaqGM", "NasdaqGS"].contains($0.exchange)
            }
        } else if exchange == "New York Stock Exchange" {
            temp = temp.filter {
                ["New York Stock Exchange", "New York Stock Exchange Arca"].contains($0.exchange)
            }
        } else if exchange == "The Stock Exchange of Hong Kong" {
            temp = temp.filter {
                ["HKSE", "HKG"].contains($0.exchange)
            }
        } else if exchange == "OTC" {
            temp = temp.filter {
                ["OTC", "Other OTC"].contains($0.exchange)
            }
        } else {
            temp = temp.filter { $0.exchange == exchange }
        }

        return temp
    }

    func fetchLocalCompanies() {
        if let url = Bundle.main.url(forResource: "companyList", withExtension: "json") {
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return }

            let json = JSON(data)

            items = []
            for jsonValue in json.arrayValue {
                let company = Company(json: jsonValue)
                items.append(company)
                companySymbolToCompanyMap[company.symbol] = company
                if let company = companyNameToCompanyMap[company.name], company.isUSCompany {
                    continue
                } else {
                    companyNameToCompanyMap[company.name] = company
                }
            }

            items = moveCompaniesToFront(moveItems: items, symbols: [
                "AAPL", "GOOG", "MSFT", "AMZN", "NFLX", "FB", "TSLA", "NVDA", "INTC", "MU", "AMD", "ORCL", "NKE", "UBER", "CSCO", "DIS", "GE", "F", "AMC", "T", "BABA", "NIO", "TWTR", "BA",
                "SPY", "FXAIX", "FSDAX", "IVV", "VTI", "VOO", "VITSX", "SPAX", "VINIX", "FDRXX", "VMFXX",
                "IVV", "VTI", "VOO", "QQQ", "DWCR", "VEA", "IEFA", "AGG", "VTV", "VUG", "BND", "VWO", "IEMG"])

            stocks = items.filter({ company in
                company.type == .stock
            })

            etfs = items.filter({ company in
                company.type == .etf
            })

            funds = items.filter({ company in
                company.type == .fund
            })
        }

        if let url = Bundle.main.url(forResource: "MajorIndexes", withExtension: "json") {
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return }

            let json = JSON(data)

            var temp = [Company]()
            for jsonValue in json.arrayValue {
                let company = Company(json: jsonValue)
                company.type = .index
                temp.append(company)
                companySymbolToCompanyMap[company.symbol] = company
                if companyNameToCompanyMap[company.name] == nil {
                    companyNameToCompanyMap[company.name] = company
                }
            }

            temp = moveCompaniesToFront(moveItems: temp, symbols: ["^GSPC", "^DJI", "^IXIC", "^NYA", "^XAX", "^RUT", "^FTSE", "^N225", "^BUK100P", "^VIX", "^GDAXI"])

            majorIndexes = temp

            items.append(contentsOf: temp)
        }

        if let url = Bundle.main.url(forResource: "Cryptocurrencies", withExtension: "json") {
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return }

            let json = JSON(data)

            var temp = [Company]()
            for jsonValue in json.arrayValue {
                let company = Company(json: jsonValue)
                company.type = .cryptocurrency
                temp.append(company)
                companySymbolToCompanyMap[company.symbol] = company
                if companyNameToCompanyMap[company.name] == nil {
                    companyNameToCompanyMap[company.name] = company
                }
            }

            temp = moveCompaniesToFront(moveItems: temp, symbols: ["BTCUSD", "ETHUSD", "BNBUSD", "DOGEUSD", "SHIBUSD", "SOL1USD", "USDTUSD", "ADAUSD", "XRPUSD", "DOT1USD", "HEXUSD", "USDCUSD", "LUNA1USD", "AVAXUSD", "UNI3USD", "LINKUSD", "LTCUSD", "MATICUSD", "ALGOUSD", "BCHUSD", "VETUSD", "AXSUSD", "XLMUSD", "CROUSD", "ICP1USD"])

            cryptocurrencies = temp

            items.append(contentsOf: temp)
        }

        if let url = Bundle.main.url(forResource: "Futures", withExtension: "json") {
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return }

            let json = JSON(data)

            var temp = [Company]()
            for jsonValue in json.arrayValue {
                let company = Company(json: jsonValue)
                company.type = .future
                temp.append(company)
                companySymbolToCompanyMap[company.symbol] = company
                if companyNameToCompanyMap[company.name] == nil {
                    companyNameToCompanyMap[company.name] = company
                }
            }

            temp = moveCompaniesToFront(moveItems: temp, symbols: ["GCUSD", "SIUSD", "ZIUSD", "CLUSD"])

            futures = temp

            items.append(contentsOf: temp)
        }

        if let url = Bundle.main.url(forResource: "ForexPrices", withExtension: "json") {
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else { return }

            let json = JSON(data)

            var temp = [Company]()
            for jsonValue in json.arrayValue {
                let company = Company(json: jsonValue)
                company.type = .forex
                temp.append(company)
                companySymbolToCompanyMap[company.symbol] = company
                if companyNameToCompanyMap[company.name] == nil {
                    companyNameToCompanyMap[company.name] = company
                }
            }

            temp = moveCompaniesToFront(moveItems: temp, symbols: ["USDGBP", "USDEUR", "USDJPY", "USDTWD", "USDCNY", "USDCHF", "USDCAD", "USDAUD", "USDSGD", "USDNZD", "USDHKD"])

            forex = temp

            items.append(contentsOf: temp)
        }
    }

    func moveCompaniesToFront(moveItems: [Company], symbols: [String]) -> [Company] {
        var temp = [Company]()
        var tempItems = moveItems
        for symbol in symbols {
            if let index = tempItems.firstIndex(where: { company in
                company.symbol == symbol
            }) {
                temp.append(tempItems.remove(at: index))
            }
        }
        return temp + tempItems
    }
}

func getFilteredCompanies(allCompanies: [Company], searchText: String, completion: @escaping ([Company]) -> Void) {
    var temp = [Company]()
    DispatchQueue.background(qos: .userInteractive) {
        let searchTextLower = searchText.lowercased()
        temp = allCompanies.filter({ (company) -> Bool in
            if company.symbol.lowercased().contains(searchTextLower) {
                return true
            }
            if company.name.lowercased().contains(searchTextLower) {
                return true
            }
            return false
        })

        temp.sort { c1, c2 in
            let s1 = c1.symbol.lowercased()
            let s2 = c2.symbol.lowercased()
            let index1: Int = s1.indexOfSubstring(subString: searchTextLower) ?? 10000
            let index2: Int = s2.indexOfSubstring(subString: searchTextLower) ?? 10000
            return index1 < index2
        }
    } completion: {
        completion(temp)
    }
}
