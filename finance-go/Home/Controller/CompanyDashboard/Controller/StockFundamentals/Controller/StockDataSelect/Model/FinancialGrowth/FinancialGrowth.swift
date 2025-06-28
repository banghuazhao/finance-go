//
//  FinancialGrowth.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class FinancialGrowth: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let revenueGrowth: Double?
    let grossProfitGrowth: Double?
    let ebitgrowth: Double?
    let operatingIncomeGrowth: Double?
    let netIncomeGrowth: Double?
    let epsgrowth: Double?
    let epsdilutedGrowth: Double?
    let weightedAverageSharesGrowth: Double?
    let weightedAverageSharesDilutedGrowth: Double?
    let dividendsperShareGrowth: Double?
    let operatingCashFlowGrowth: Double?
    let freeCashFlowGrowth: Double?
    let tenYRevenueGrowthPerShare: Double?
    let fiveYRevenueGrowthPerShare: Double?
    let threeYRevenueGrowthPerShare: Double?
    let tenYOperatingCFGrowthPerShare: Double?
    let fiveYOperatingCFGrowthPerShare: Double?
    let threeYOperatingCFGrowthPerShare: Double?
    let tenYNetIncomeGrowthPerShare: Double?
    let fiveYNetIncomeGrowthPerShare: Double?
    let threeYNetIncomeGrowthPerShare: Double?
    let tenYShareholdersEquityGrowthPerShare: Double?
    let fiveYShareholdersEquityGrowthPerShare: Double?
    let threeYShareholdersEquityGrowthPerShare: Double?
    let tenYDividendperShareGrowthPerShare: Double?
    let fiveYDividendperShareGrowthPerShare: Double?
    let threeYDividendperShareGrowthPerShare: Double?
    let receivablesGrowth: Double?
    let inventoryGrowth: Double?
    let assetGrowth: Double?
    let bookValueperShareGrowth: Double?
    let debtGrowth: Double?
    let rdexpenseGrowth: Double?
    let sgaexpensesGrowth: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        revenueGrowth = dict["revenueGrowth"].double
        grossProfitGrowth = dict["grossProfitGrowth"].double
        ebitgrowth = dict["ebitgrowth"].double
        operatingIncomeGrowth = dict["operatingIncomeGrowth"].double
        netIncomeGrowth = dict["netIncomeGrowth"].double
        epsgrowth = dict["epsgrowth"].double
        epsdilutedGrowth = dict["epsdilutedGrowth"].double
        weightedAverageSharesGrowth = dict["weightedAverageSharesGrowth"].double
        weightedAverageSharesDilutedGrowth = dict["weightedAverageSharesDilutedGrowth"].double
        dividendsperShareGrowth = dict["dividendsperShareGrowth"].double
        operatingCashFlowGrowth = dict["operatingCashFlowGrowth"].double
        freeCashFlowGrowth = dict["freeCashFlowGrowth"].double
        tenYRevenueGrowthPerShare = dict["tenYRevenueGrowthPerShare"].double
        fiveYRevenueGrowthPerShare = dict["fiveYRevenueGrowthPerShare"].double
        threeYRevenueGrowthPerShare = dict["threeYRevenueGrowthPerShare"].double
        tenYOperatingCFGrowthPerShare = dict["tenYOperatingCFGrowthPerShare"].double
        fiveYOperatingCFGrowthPerShare = dict["fiveYOperatingCFGrowthPerShare"].double
        threeYOperatingCFGrowthPerShare = dict["threeYOperatingCFGrowthPerShare"].double
        tenYNetIncomeGrowthPerShare = dict["tenYNetIncomeGrowthPerShare"].double
        fiveYNetIncomeGrowthPerShare = dict["fiveYNetIncomeGrowthPerShare"].double
        threeYNetIncomeGrowthPerShare = dict["threeYNetIncomeGrowthPerShare"].double
        tenYShareholdersEquityGrowthPerShare = dict["tenYShareholdersEquityGrowthPerShare"].double
        fiveYShareholdersEquityGrowthPerShare = dict["fiveYShareholdersEquityGrowthPerShare"].double
        threeYShareholdersEquityGrowthPerShare = dict["threeYShareholdersEquityGrowthPerShare"].double
        tenYDividendperShareGrowthPerShare = dict["tenYDividendperShareGrowthPerShare"].double
        fiveYDividendperShareGrowthPerShare = dict["fiveYDividendperShareGrowthPerShare"].double
        threeYDividendperShareGrowthPerShare = dict["threeYDividendperShareGrowthPerShare"].double
        receivablesGrowth = dict["receivablesGrowth"].double
        inventoryGrowth = dict["inventoryGrowth"].double
        assetGrowth = dict["assetGrowth"].double
        bookValueperShareGrowth = dict["bookValueperShareGrowth"].double
        debtGrowth = dict["debtGrowth"].double
        rdexpenseGrowth = dict["rdexpenseGrowth"].double
        sgaexpensesGrowth = dict["sgaexpensesGrowth"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Revenue Growth",
                      key: "revenueGrowth",
                      value: revenueGrowth),
            StockData(name: "Gross Profit Growth",
                      key: "grossProfitGrowth",
                      value: grossProfitGrowth),
            StockData(name: "EBIT Growth",
                      key: "ebitgrowth",
                      value: ebitgrowth),
            StockData(name: "Operating Income Growth",
                      key: "operatingIncomeGrowth",
                      value: operatingIncomeGrowth),
            StockData(name: "Net Income Growth",
                      key: "netIncomeGrowth",
                      value: netIncomeGrowth),
            StockData(name: "EPS Growth",
                      key: "epsgrowth",
                      value: epsgrowth),
            StockData(name: "EPS Diluted Growth",
                      key: "epsdilutedGrowth",
                      value: epsdilutedGrowth),
            StockData(name: "Eeighted Average Shares Growth",
                      key: "weightedAverageSharesGrowth",
                      value: weightedAverageSharesGrowth),
            StockData(name: "Eeighted Average Shares Diluted Growth",
                      key: "weightedAverageSharesDilutedGrowth",
                      value: weightedAverageSharesDilutedGrowth),
            StockData(name: "Dividends Per Share Growth",
                      key: "dividendsperShareGrowth",
                      value: dividendsperShareGrowth),
            StockData(name: "Operating Cash Flow Growth",
                      key: "operatingCashFlowGrowth",
                      value: operatingCashFlowGrowth),
            StockData(name: "Free Cash Flow Growth",
                      key: "freeCashFlowGrowth",
                      value: freeCashFlowGrowth),
            StockData(name: "Ten Year Revenue Growth Per Share",
                      key: "tenYRevenueGrowthPerShare",
                      value: tenYRevenueGrowthPerShare),
            StockData(name: "Five Year Revenue Growth Per Share",
                      key: "fiveYRevenueGrowthPerShare",
                      value: fiveYRevenueGrowthPerShare),
            StockData(name: "Three Year Revenue Growth Per Share",
                      key: "threeYRevenueGrowthPerShare",
                      value: threeYRevenueGrowthPerShare),
            StockData(name: "Ten Year Operating CF Growth Per Share",
                      key: "tenYOperatingCFGrowthPerShare",
                      value: tenYOperatingCFGrowthPerShare),
            StockData(name: "Five Year Operating CF Growth Per Share",
                      key: "fiveYOperatingCFGrowthPerShare",
                      value: fiveYOperatingCFGrowthPerShare),
            StockData(name: "Three Year Operating CF Growth Per Share",
                      key: "threeYOperatingCFGrowthPerShare",
                      value: threeYOperatingCFGrowthPerShare),
            StockData(name: "Ten Year Net Income Growth Per Share",
                      key: "tenYNetIncomeGrowthPerShare",
                      value: tenYNetIncomeGrowthPerShare),
            StockData(name: "Five Year Net Income Growth Per Share",
                      key: "fiveYNetIncomeGrowthPerShare",
                      value: fiveYNetIncomeGrowthPerShare),
            StockData(name: "Three Year Net Income Growth Per Share",
                      key: "threeYNetIncomeGrowthPerShare",
                      value: threeYNetIncomeGrowthPerShare),
            StockData(name: "Ten Year Shareholders Equity Growth Per Share",
                      key: "tenYShareholdersEquityGrowthPerShare",
                      value: tenYShareholdersEquityGrowthPerShare),
            StockData(name: "Five Year Shareholders Equity Growth Per Share",
                      key: "fiveYShareholdersEquityGrowthPerShare",
                      value: fiveYShareholdersEquityGrowthPerShare),
            StockData(name: "Three Year Shareholders Equity Growth Per Share",
                      key: "threeYShareholdersEquityGrowthPerShare",
                      value: threeYShareholdersEquityGrowthPerShare),
            StockData(name: "Ten Year Dividend Per Share Growth Per Share",
                      key: "tenYDividendperShareGrowthPerShare",
                      value: tenYDividendperShareGrowthPerShare),
            StockData(name: "Five Year Dividend Per Share Growth Per Share",
                      key: "fiveYDividendperShareGrowthPerShare",
                      value: fiveYDividendperShareGrowthPerShare),
            StockData(name: "Three Year Dividend Per Share Growth Per Share",
                      key: "threeYDividendperShareGrowthPerShare",
                      value: threeYDividendperShareGrowthPerShare),
            StockData(name: "Receivables Growth",
                      key: "receivablesGrowth",
                      value: receivablesGrowth),
            StockData(name: "Inventory Growth",
                      key: "inventoryGrowth",
                      value: inventoryGrowth),
            StockData(name: "Asset Growth",
                      key: "assetGrowth",
                      value: assetGrowth),
            StockData(name: "Book Value Per Share Growth",
                      key: "bookValueperShareGrowth",
                      value: bookValueperShareGrowth),
            StockData(name: "DEBT Growth",
                      key: "debtGrowth",
                      value: debtGrowth),
            StockData(name: "R&D expense Growth",
                      key: "rdexpenseGrowth",
                      value: rdexpenseGrowth),
            StockData(name: "SGA Expenses Growth",
                      key: "sgaexpensesGrowth",
                      value: sgaexpensesGrowth),
        ]
    }
}
