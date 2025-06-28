//
//  WatchCompanyHelper.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/8.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension UserDefaultsKeys {
    static let haveTransferFromCoreData = "haveTransferFromCoreData"
    static let haveInitialDefaultWatchlist = "haveInitialDefaultWatchlist"
    static let watchCompanySymbols = "watchCompanySymbols"
}

class WatchCompanyHelper {
    static func transferWatchCompanyFromCoreDataToUserDefaultsIfNeeded() {
        let haveTransferFromCoreData = UserDefaults.standard.bool(forKey: UserDefaultsKeys.haveTransferFromCoreData)

        if !haveTransferFromCoreData {
            let watchCompanies = CoreDataManager.shared.fetchWatchCompanies()
            var watchCompanySymbols = [String]()
            for watchCompany in watchCompanies {
                if let symbol = watchCompany.symbol {
                    watchCompanySymbols.append(symbol)
                }
            }
            UserDefaults.standard.set(watchCompanySymbols, forKey: UserDefaultsKeys.watchCompanySymbols)
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.haveTransferFromCoreData)
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.haveTransferFromCoreData)
        }
    }

    static func initialDefaultWatchlist() {
        let haveInitialDefaultWatchlist = UserDefaults.standard.bool(forKey: UserDefaultsKeys.haveInitialDefaultWatchlist)

        if !haveInitialDefaultWatchlist {
            if WatchCompanyHelper.getAllWatchCompanies().count == 0 {
                UserDefaults.standard.set(["AAPL", "GOOG", "MSFT", "BTCUSD", "TSLA", "FB"], forKey: UserDefaultsKeys.watchCompanySymbols)
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.haveInitialDefaultWatchlist)
            }
        }
    }

    static func getAllWatchCompanySymbols() -> [String] {
        guard let watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else { return [] }
        return watchCompanySymbols
    }

    static func getAllWatchCompanies() -> [Company] {
        guard let watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else {
            return []
        }
        var companies = [Company]()
        for watchCompanySymbol in watchCompanySymbols {
            if let company = CompanyStore.shared.item(symbol: watchCompanySymbol) {
                companies.append(company)
            }
        }
        return companies
    }

    static func appendWatchCompanySymbol(company: Company) {
        guard var watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else {
            UserDefaults.standard.set([company.symbol], forKey: UserDefaultsKeys.watchCompanySymbols)
            return
        }
        watchCompanySymbols.append(company.symbol)
        UserDefaults.standard.set(watchCompanySymbols, forKey: UserDefaultsKeys.watchCompanySymbols)
    }

    static func removeWatchCompanySymbol(company: Company) {
        guard var watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else { return }
        watchCompanySymbols.removeAll { symbol in
            symbol == company.symbol
        }
        UserDefaults.standard.set(watchCompanySymbols, forKey: UserDefaultsKeys.watchCompanySymbols)
    }

    static func removeWatchCompanySymbol(index: Int) {
        guard var watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else { return }
        if index < watchCompanySymbols.count && index >= 0 {
            watchCompanySymbols.remove(at: index)
            UserDefaults.standard.set(watchCompanySymbols, forKey: UserDefaultsKeys.watchCompanySymbols)
        }
    }

    static func insertWatchCompanySymbol(company: Company, index: Int) {
        guard var watchCompanySymbols = UserDefaults.standard.object(forKey: UserDefaultsKeys.watchCompanySymbols) as? [String] else {
            if index == 0 {
                UserDefaults.standard.set([company.symbol], forKey: UserDefaultsKeys.watchCompanySymbols)
            }
            return
        }
        if index <= watchCompanySymbols.count && index >= 0 {
            watchCompanySymbols.insert(company.symbol, at: index)
            UserDefaults.standard.set(watchCompanySymbols, forKey: UserDefaultsKeys.watchCompanySymbols)
        }
    }
}
