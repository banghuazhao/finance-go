//
//  StockData.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

class StockData: Equatable {
    enum DataType {
        case decimal
        case ratio
        case original
    }

    let name: String
    let key: String
    var value: Double?
    var financialTerm: FinancialTerm?
    var dataType: DataType

    init(name: String, key: String, value: Double? = nil) {
        self.name = name
        self.key = key
        self.value = value
        financialTerm = nil

        if self.name.contains("Ratios") || self.name.contains("Ratio") || self.name.contains("Margin") || self.name.contains("Margins") || self.name.contains("Rate") || self.name.contains("Return") || self.name.contains("Turnover") || self.name.contains(" to ") {
            dataType = .ratio
        } else if self.name.contains("Growth") {
            dataType = .original
        } else {
            dataType = .decimal
        }

        if let financialTerm = FinancialTermStore.shared.items.first(where: { (ft) -> Bool in
            ft.name == self.name
        }) {
            self.financialTerm = financialTerm
        }
    }
    
    static func == (lhs: StockData, rhs: StockData) -> Bool {
        return lhs.name == rhs.name && lhs.key == rhs.key && lhs.value == rhs.value
    }
}
