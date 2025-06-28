//
//  KeyMetrix.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class KeyMetrix: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let revenuePerShare: Double?
    let netIncomePerShare: Double?
    let operatingCashFlowPerShare: Double?
    let freeCashFlowPerShare: Double?
    let cashPerShare: Double?
    let bookValuePerShare: Double?
    let tangibleBookValuePerShare: Double?
    let shareholdersEquityPerShare: Double?
    let interestDebtPerShare: Double?
    let marketCap: Double?
    let enterpriseValue: Double?
    let peRatio: Double?
    let priceToSalesRatio: Double?
    let pocfratio: Double?
    let pfcfRatio: Double?
    let pbRatio: Double?
    let ptbRatio: Double?
    let evToSales: Double?
    let enterpriseValueOverEBITDA: Double?
    let evToOperatingCashFlow: Double?
    let evToFreeCashFlow: Double?
    let earningsYield: Double?
    let freeCashFlowYield: Double?
    let debtToEquity: Double?
    let debtToAssets: Double?
    let netDebtToEBITDA: Double?
    let currentRatio: Double?
    let interestCoverage: Double?
    let incomeQuality: Double?
    let dividendYield: Double?
    let payoutRatio: Double?
    let salesGeneralAndAdministrativeToRevenue: Double?
    let researchAndDdevelopementToRevenue: Double?
    let intangiblesToTotalAssets: Double?
    let capexToOperatingCashFlow: Double?
    let capexToRevenue: Double?
    let capexToDepreciation: Double?
    let stockBasedCompensationToRevenue: Double?
    let grahamNumber: Double?
    let roic: Double?
    let returnOnTangibleAssets: Double?
    let grahamNetNet: Double?
    let workingCapital: Double?
    let tangibleAssetValue: Double?
    let netCurrentAssetValue: Double?
    let investedCapital: Double?
    let averageReceivables: Double?
    let averagePayables: Double?
    let averageInventory: Double?
    let daysSalesOutstanding: Double?
    let daysPayablesOutstanding: Double?
    let daysOfInventoryOnHand: Double?
    let receivablesTurnover: Double?
    let payablesTurnover: Double?
    let inventoryTurnover: Double?
    let roe: Double?
    let capexPerShare: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        revenuePerShare = dict["revenuePerShare"].double
        netIncomePerShare = dict["netIncomePerShare"].double
        operatingCashFlowPerShare = dict["operatingCashFlowPerShare"].double
        freeCashFlowPerShare = dict["freeCashFlowPerShare"].double
        cashPerShare = dict["cashPerShare"].double
        bookValuePerShare = dict["bookValuePerShare"].double
        tangibleBookValuePerShare = dict["tangibleBookValuePerShare"].double
        shareholdersEquityPerShare = dict["shareholdersEquityPerShare"].double
        interestDebtPerShare = dict["interestDebtPerShare"].double
        marketCap = dict["marketCap"].double
        enterpriseValue = dict["enterpriseValue"].double
        peRatio = dict["peRatio"].double
        priceToSalesRatio = dict["priceToSalesRatio"].double
        pocfratio = dict["pocfratio"].double
        pfcfRatio = dict["pfcfRatio"].double
        pbRatio = dict["pbRatio"].double
        ptbRatio = dict["ptbRatio"].double
        evToSales = dict["evToSales"].double
        enterpriseValueOverEBITDA = dict["enterpriseValueOverEBITDA"].double
        evToOperatingCashFlow = dict["evToOperatingCashFlow"].double
        evToFreeCashFlow = dict["evToFreeCashFlow"].double
        earningsYield = dict["earningsYield"].double
        freeCashFlowYield = dict["freeCashFlowYield"].double
        debtToEquity = dict["debtToEquity"].double
        debtToAssets = dict["debtToAssets"].double
        netDebtToEBITDA = dict["netDebtToEBITDA"].double
        currentRatio = dict["currentRatio"].double
        interestCoverage = dict["interestCoverage"].double
        incomeQuality = dict["incomeQuality"].double
        dividendYield = dict["dividendYield"].double
        payoutRatio = dict["payoutRatio"].double
        salesGeneralAndAdministrativeToRevenue = dict["salesGeneralAndAdministrativeToRevenue"].double
        researchAndDdevelopementToRevenue = dict["researchAndDdevelopementToRevenue"].double
        intangiblesToTotalAssets = dict["intangiblesToTotalAssets"].double
        capexToOperatingCashFlow = dict["capexToOperatingCashFlow"].double
        capexToRevenue = dict["capexToRevenue"].double
        capexToDepreciation = dict["capexToDepreciation"].double
        stockBasedCompensationToRevenue = dict["stockBasedCompensationToRevenue"].double
        grahamNumber = dict["grahamNumber"].double
        roic = dict["roic"].double
        returnOnTangibleAssets = dict["returnOnTangibleAssets"].double
        grahamNetNet = dict["grahamNetNet"].double
        workingCapital = dict["workingCapital"].double
        tangibleAssetValue = dict["tangibleAssetValue"].double
        netCurrentAssetValue = dict["netCurrentAssetValue"].double
        investedCapital = dict["investedCapital"].double
        averageReceivables = dict["averageReceivables"].double
        averagePayables = dict["averagePayables"].double
        averageInventory = dict["averageInventory"].double
        daysSalesOutstanding = dict["daysSalesOutstanding"].double
        daysPayablesOutstanding = dict["daysPayablesOutstanding"].double
        daysOfInventoryOnHand = dict["daysOfInventoryOnHand"].double
        receivablesTurnover = dict["receivablesTurnover"].double
        payablesTurnover = dict["payablesTurnover"].double
        inventoryTurnover = dict["inventoryTurnover"].double
        roe = dict["roe"].double
        capexPerShare = dict["capexPerShare"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Current Ratio",
                      key: "currentRatio",
                      value: currentRatio),
            StockData(name: "Interest Coverage",
                      key: "interestCoverage",
                      value: interestCoverage),
            StockData(name: "Revenue Per Share",
                      key: "revenuePerShare",
                      value: revenuePerShare),
            StockData(name: "Net Income Per Share",
                      key: "netIncomePerShare",
                      value: netIncomePerShare),
            StockData(name: "Operating Cash Flow Per Share",
                      key: "operatingCashFlowPerShare",
                      value: operatingCashFlowPerShare),
            StockData(name: "Free Cash Flow Per Share",
                      key: "freeCashFlowPerShare",
                      value: freeCashFlowPerShare),
            StockData(name: "Cash Per Share",
                      key: "cashPerShare",
                      value: cashPerShare),
            StockData(name: "Book Value Per Share",
                      key: "bookValuePerShare",
                      value: bookValuePerShare),
            StockData(name: "Tangible Book Value Per Share",
                      key: "tangibleBookValuePerShare",
                      value: tangibleBookValuePerShare),
            StockData(name: "Shareholders Equity Per Share",
                      key: "shareholdersEquityPerShare",
                      value: shareholdersEquityPerShare),
            StockData(name: "Interest Debt Per Share",
                      key: "interestDebtPerShare",
                      value: interestDebtPerShare),
            StockData(name: "Market Cap",
                      key: "marketCap",
                      value: marketCap),
            StockData(name: "Enterprise Value",
                      key: "enterpriseValue",
                      value: enterpriseValue),
            StockData(name: "PE Ratio",
                      key: "peRatio",
                      value: peRatio),
            StockData(name: "Price to Sales Ratio",
                      key: "priceToSalesRatio",
                      value: priceToSalesRatio),
            StockData(name: "POCF ratio",
                      key: "pocfratio",
                      value: pocfratio),
            StockData(name: "PFCF Ratio",
                      key: "pfcfRatio",
                      value: pfcfRatio),
            StockData(name: "PB Ratio",
                      key: "pbRatio",
                      value: pbRatio),
            StockData(name: "PTB Ratio",
                      key: "ptbRatio",
                      value: ptbRatio),
            StockData(name: "EV to Sales",
                      key: "evToSales",
                      value: evToSales),
            StockData(name: "Enterprise Value Over EBITDA",
                      key: "enterpriseValueOverEBITDA",
                      value: enterpriseValueOverEBITDA),
            StockData(name: "EV to Operating Cash Flow",
                      key: "evToOperatingCashFlow",
                      value: evToOperatingCashFlow),
            StockData(name: "EV to Free Cash Flow",
                      key: "evToFreeCashFlow",
                      value: evToFreeCashFlow),
            StockData(name: "Earnings Yield",
                      key: "earningsYield",
                      value: earningsYield),
            StockData(name: "Free Cash Flow Yield",
                      key: "freeCashFlowYield",
                      value: freeCashFlowYield),
            StockData(name: "Debt to Assets",
                      key: "debtToAssets",
                      value: debtToAssets),
            StockData(name: "Net Debt to EBITDA",
                      key: "netDebtToEBITDA",
                      value: netDebtToEBITDA),
            StockData(name: "Income Quality",
                      key: "incomeQuality",
                      value: incomeQuality),
            StockData(name: "Dividend Yield",
                      key: "dividendYield",
                      value: dividendYield),
            StockData(name: "Payout Ratio",
                      key: "payoutRatio",
                      value: payoutRatio),
            StockData(name: "Sales General and Administrative to Revenue",
                      key: "salesGeneralAndAdministrativeToRevenue",
                      value: salesGeneralAndAdministrativeToRevenue),
            StockData(name: "Research and Ddevelopement to Revenue",
                      key: "researchAndDdevelopementToRevenue",
                      value: researchAndDdevelopementToRevenue),
            StockData(name: "Intangibles to Total Assets",
                      key: "intangiblesToTotalAssets",
                      value: intangiblesToTotalAssets),
            StockData(name: "Capex to Operating Cash Flow",
                      key: "capexToOperatingCashFlow",
                      value: capexToOperatingCashFlow),
            StockData(name: "CAPEX to Revenue",
                      key: "capexToRevenue",
                      value: capexToRevenue),
            StockData(name: "Capex to Depreciation",
                      key: "capexToDepreciation",
                      value: capexToDepreciation),
            StockData(name: "Stock Based Compensation to Revenue",
                      key: "stockBasedCompensationToRevenue",
                      value: stockBasedCompensationToRevenue),
            StockData(name: "Graham Number",
                      key: "grahamNumber",
                      value: grahamNumber),
            StockData(name: "ROIC",
                      key: "roic",
                      value: roic),
            StockData(name: "Return on Tangible Assets",
                      key: "returnOnTangibleAssets",
                      value: returnOnTangibleAssets),
            StockData(name: "GrahamNet Net",
                      key: "grahamNetNet",
                      value: grahamNetNet),
            StockData(name: "Working Capital",
                      key: "workingCapital",
                      value: workingCapital),
            StockData(name: "Tangible Asset Value",
                      key: "tangibleAssetValue",
                      value: tangibleAssetValue),
            StockData(name: "Net Current Asset Value",
                      key: "netCurrentAssetValue",
                      value: netCurrentAssetValue),
            StockData(name: "Invested Capital",
                      key: "investedCapital",
                      value: investedCapital),
            StockData(name: "Average Receivables",
                      key: "averageReceivables",
                      value: averageReceivables),
            StockData(name: "Average Payables",
                      key: "averagePayables",
                      value: averagePayables),
            StockData(name: "Average Inventory",
                      key: "averageInventory",
                      value: averageInventory),
            StockData(name: "Days Sales Outstanding",
                      key: "daysSalesOutstanding",
                      value: daysSalesOutstanding),
            StockData(name: "Days Payables Outstanding",
                      key: "daysPayablesOutstanding",
                      value: daysPayablesOutstanding),
            StockData(name: "Days of Inventory on Hand",
                      key: "daysOfInventoryOnHand",
                      value: daysOfInventoryOnHand),
            StockData(name: "Receivables Turnover",
                      key: "receivablesTurnover",
                      value: receivablesTurnover),
            StockData(name: "Payables Turnover",
                      key: "payablesTurnover",
                      value: payablesTurnover),
            StockData(name: "Inventory Turnover",
                      key: "inventoryTurnover",
                      value: inventoryTurnover),
            StockData(name: "ROE",
                      key: "roe",
                      value: roe),
            StockData(name: "Debt to Equity",
                      key: "debtToEquity",
                      value: debtToEquity),
            StockData(name: "CAPEX Per Share",
                      key: "capexPerShare",
                      value: capexPerShare),
        ]
    }
}
