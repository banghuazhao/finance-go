//
//  BalanceSheetStatement.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class BalanceSheetStatement: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let cashAndCashEquivalents: Double?
    let shortTermInvestments: Double?
    let cashAndShortTermInvestments: Double?
    let netReceivables: Double?
    let inventory: Double?
    let otherCurrentAssets: Double?
    let totalCurrentAssets: Double?
    let propertyPlantEquipmentNet: Double?
    let goodwill: Double?
    let intangibleAssets: Double?
    let goodwillAndIntangibleAssets: Double?
    let longTermInvestments: Double?
    let taxAssets: Double?
    let otherNonCurrentAssets: Double?
    let totalNonCurrentAssets: Double?
    let otherAssets: Double?
    let totalAssets: Double?
    let accountPayables: Double?
    let shortTermDebt: Double?
    let taxPayables: Double?
    let deferredRevenue: Double?
    let otherCurrentLiabilities: Double?
    let totalCurrentLiabilities: Double?
    let longTermDebt: Double?
    let deferredRevenueNonCurrent: Double?
    let deferredTaxLiabilitiesNonCurrent: Double?
    let otherNonCurrentLiabilities: Double?
    let totalNonCurrentLiabilities: Double?
    let otherLiabilities: Double?
    let totalLiabilities: Double?
    let commonStock: Double?
    let retainedEarnings: Double?
    let accumulatedOtherComprehensiveIncomeLoss: Double?
    let othertotalStockholdersEquity: Double?
    let totalStockholdersEquity: Double?
    let totalLiabilitiesAndStockholdersEquity: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        cashAndCashEquivalents = dict["cashAndCashEquivalents"].double
        shortTermInvestments = dict["shortTermInvestments"].double
        cashAndShortTermInvestments = dict["cashAndShortTermInvestments"].double
        netReceivables = dict["netReceivables"].double
        inventory = dict["inventory"].double
        otherCurrentAssets = dict["otherCurrentAssets"].double
        totalCurrentAssets = dict["totalCurrentAssets"].double
        propertyPlantEquipmentNet = dict["propertyPlantEquipmentNet"].double
        goodwill = dict["goodwill"].double
        intangibleAssets = dict["intangibleAssets"].double
        goodwillAndIntangibleAssets = dict["goodwillAndIntangibleAssets"].double
        longTermInvestments = dict["longTermInvestments"].double
        taxAssets = dict["taxAssets"].double
        otherNonCurrentAssets = dict["otherNonCurrentAssets"].double
        totalNonCurrentAssets = dict["totalNonCurrentAssets"].double
        otherAssets = dict["otherAssets"].double
        totalAssets = dict["totalAssets"].double
        accountPayables = dict["accountPayables"].double
        shortTermDebt = dict["shortTermDebt"].double
        taxPayables = dict["taxPayables"].double
        deferredRevenue = dict["deferredRevenue"].double
        otherCurrentLiabilities = dict["otherCurrentLiabilities"].double
        totalCurrentLiabilities = dict["totalCurrentLiabilities"].double
        longTermDebt = dict["longTermDebt"].double
        deferredRevenueNonCurrent = dict["deferredRevenueNonCurrent"].double
        deferredTaxLiabilitiesNonCurrent = dict["deferredTaxLiabilitiesNonCurrent"].double
        otherNonCurrentLiabilities = dict["otherNonCurrentLiabilities"].double
        totalNonCurrentLiabilities = dict["totalNonCurrentLiabilities"].double
        otherLiabilities = dict["otherLiabilities"].double
        totalLiabilities = dict["totalLiabilities"].double
        commonStock = dict["commonStock"].double
        retainedEarnings = dict["retainedEarnings"].double
        accumulatedOtherComprehensiveIncomeLoss = dict["accumulatedOtherComprehensiveIncomeLoss"].double
        othertotalStockholdersEquity = dict["othertotalStockholdersEquity"].double
        totalStockholdersEquity = dict["totalStockholdersEquity"].double
        totalLiabilitiesAndStockholdersEquity = dict["totalLiabilitiesAndStockholdersEquity"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Cash and Cash Equivalents",
                      key: "cashAndCashEquivalents",
                      value: cashAndCashEquivalents),
            StockData(name: "Short Term Investments",
                      key: "shortTermInvestments",
                      value: shortTermInvestments),
            StockData(name: "Cash and Short Term",
                      key: "cashAndShortTermInvestments",
                      value: cashAndShortTermInvestments),
            StockData(name: "Net Receivables",
                      key: "netReceivables",
                      value: netReceivables),
            StockData(name: "Inventory",
                      key: "inventory",
                      value: inventory),
            StockData(name: "Other Current Assets",
                      key: "otherCurrentAssets",
                      value: otherCurrentAssets),
            StockData(name: "Total Current Assets",
                      key: "totalCurrentAssets",
                      value: totalCurrentAssets),
            StockData(name: "Property Plant EquipmentNet",
                      key: "propertyPlantEquipmentNet",
                      value: propertyPlantEquipmentNet),
            StockData(name: "Goodwill",
                      key: "goodwill",
                      value: goodwill),
            StockData(name: "Intangible Assets",
                      key: "intangibleAssets",
                      value: intangibleAssets),
            StockData(name: "Goodwill and Intangible Assets",
                      key: "goodwillAndIntangibleAssets",
                      value: goodwillAndIntangibleAssets),
            StockData(name: "Long Term Investments",
                      key: "longTermInvestments",
                      value: longTermInvestments),
            StockData(name: "Tax Assets",
                      key: "taxAssets",
                      value: taxAssets),
            StockData(name: "Other NonCurrent Assets",
                      key: "otherNonCurrentAssets",
                      value: otherNonCurrentAssets),
            StockData(name: "Total NonCurrent Assets",
                      key: "totalNonCurrentAssets",
                      value: totalNonCurrentAssets),
            StockData(name: "Other Assets",
                      key: "otherAssets",
                      value: otherAssets),
            StockData(name: "Total Assets",
                      key: "totalAssets",
                      value: totalAssets),
            StockData(name: "Account Payables",
                      key: "accountPayables",
                      value: accountPayables),
            StockData(name: "Short Term Debt",
                      key: "shortTermDebt",
                      value: shortTermDebt),
            StockData(name: "Tax Payables",
                      key: "taxPayables",
                      value: taxPayables),
            StockData(name: "Deferred Revenue",
                      key: "deferredRevenue",
                      value: deferredRevenue),
            StockData(name: "Other Current Liabilities",
                      key: "otherCurrentLiabilities",
                      value: otherCurrentLiabilities),
            StockData(name: "Total Current Liabilities",
                      key: "totalCurrentLiabilities",
                      value: totalCurrentLiabilities),
            StockData(name: "Long Term Debt",
                      key: "longTermDebt",
                      value: longTermDebt),
            StockData(name: "Deferred Revenue NonCurrent",
                      key: "deferredRevenueNonCurrent",
                      value: deferredRevenueNonCurrent),
            StockData(name: "Deferred Tax Liabilities NonCurrent",
                      key: "deferredTaxLiabilitiesNonCurrent",
                      value: deferredTaxLiabilitiesNonCurrent),
            StockData(name: "Other Non Current Liabilities",
                      key: "otherNonCurrentLiabilities",
                      value: otherNonCurrentLiabilities),
            StockData(name: "Total Non Current Liabilities",
                      key: "totalNonCurrentLiabilities",
                      value: totalNonCurrentLiabilities),
            StockData(name: "Other Liabilities",
                      key: "otherLiabilities",
                      value: otherLiabilities),
            StockData(name: "Total Liabilities",
                      key: "totalLiabilities",
                      value: totalLiabilities),
            StockData(name: "Common Stock",
                      key: "commonStock",
                      value: commonStock),
            StockData(name: "Retained Earnings",
                      key: "retainedEarnings",
                      value: retainedEarnings),
            StockData(name: "Accumulated Other Comprehensive Income Loss",
                      key: "accumulatedOtherComprehensiveIncomeLoss",
                      value: accumulatedOtherComprehensiveIncomeLoss),
            StockData(name: "Other Total Stockholders Equity",
                      key: "othertotalStockholdersEquity",
                      value: othertotalStockholdersEquity),
            StockData(name: "Total Stockholders Equity",
                      key: "totalStockholdersEquity",
                      value: totalStockholdersEquity),
            StockData(name: "Total Liabilities and StockholdersEquity",
                      key: "totalLiabilitiesAndStockholdersEquity",
                      value: totalLiabilitiesAndStockholdersEquity),
        ]
    }
}
