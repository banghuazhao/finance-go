//
//  BookmarkHelper.swift
//  Novels Hub
//
//  Created by Banghua Zhao on 2021/9/25.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class FiscalPeriodCompareHelper {
    static func setCompare(financialBase: FinancialBase, isCompare: Bool) {
        UserDefaults.standard.set(isCompare, forKey: "fiscalPeriodCompareName: \(financialBase.name)")
    }

    static func getCompare(financialBase: FinancialBase) -> Bool {
        if let value =  UserDefaults.standard.value(forKey: "fiscalPeriodCompareName: \(financialBase.name)") {
            return (value as? Bool) ?? true
        }
        return true
    }
}
