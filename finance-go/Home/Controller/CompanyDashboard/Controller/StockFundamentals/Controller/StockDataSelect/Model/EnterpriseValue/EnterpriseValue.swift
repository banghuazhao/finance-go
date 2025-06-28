//
//  EnterpriseValue.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class EnterpriseValue: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let stockPrice: Double?
    let numberOfShares: Double?
    let marketCapitalization: Double?
    let minusCashAndCashEquivalents: Double?
    let addTotalDebt: Double?
    let enterpriseValue: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        stockPrice = dict["stockPrice"].double
        numberOfShares = dict["numberOfShares"].double
        marketCapitalization = dict["marketCapitalization"].double
        minusCashAndCashEquivalents = dict["minusCashAndCashEquivalents"].double
        addTotalDebt = dict["addTotalDebt"].double
        enterpriseValue = dict["enterpriseValue"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Stock Price",
                      key: "stockPrice",
                      value: stockPrice),
            StockData(name: "Number of Shares",
                      key: "numberOfShares",
                      value: numberOfShares),
            StockData(name: "Market Capitalization",
                      key: "marketCapitalization",
                      value: marketCapitalization),
            StockData(name: "Minus Cash and Cash Equivalents",
                      key: "minusCashAndCashEquivalents",
                      value: minusCashAndCashEquivalents),
            StockData(name: "Add Total Debt",
                      key: "addTotalDebt",
                      value: addTotalDebt),
            StockData(name: "Enterprise Value",
                      key: "enterpriseValue",
                      value: enterpriseValue),
        ]
    }
}
