//
//  SearchHistoryHelper.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/14.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension UserDefaultsKeys {
    static let searchCompanyHistory = "searchCompanyHistory"
}

class SearchHistoryHelper {
    static func getAllSearchHistory() -> [String] {
        guard let searchCompanyHistory = UserDefaults.standard.object(forKey: UserDefaultsKeys.searchCompanyHistory) as? [String] else { return [] }
        return searchCompanyHistory
    }

    static func appendSearchHistory(history: String) {
        guard var searchCompanyHistory = UserDefaults.standard.object(forKey: UserDefaultsKeys.searchCompanyHistory) as? [String] else {
            UserDefaults.standard.set([history], forKey: UserDefaultsKeys.searchCompanyHistory)
            return
        }
        if !searchCompanyHistory.contains(history) {
            searchCompanyHistory.append(history)
            UserDefaults.standard.set(searchCompanyHistory, forKey: UserDefaultsKeys.searchCompanyHistory)
        }
    }

    static func removeSearchHistory(history: String) {
        guard var searchCompanyHistory = UserDefaults.standard.object(forKey: UserDefaultsKeys.searchCompanyHistory) as? [String] else { return }
        searchCompanyHistory.removeAll { searchHistory in
            searchHistory == history
        }
        UserDefaults.standard.set(searchCompanyHistory, forKey: UserDefaultsKeys.searchCompanyHistory)
    }

    static func removeAllSearchHistory() {
        UserDefaults.standard.set([], forKey: UserDefaultsKeys.searchCompanyHistory)
    }
}
