//
//  FinancialRatios.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class FinancialRatio: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let currentRatio: Double?
    let quickRatio: Double?
    let cashRatio: Double?
    let daysOfSalesOutstanding: Double?
    let daysOfInventoryOutstanding: Double?
    let operatingCycle: Double?
    let daysOfPayablesOutstanding: Double?
    let cashConversionCycle: Double?
    let grossProfitMargin: Double?
    let operatingProfitMargin: Double?
    let pretaxProfitMargin: Double?
    let netProfitMargin: Double?
    let effectiveTaxRate: Double?
    let returnOnAssets: Double?
    let returnOnEquity: Double?
    let returnOnCapitalEmployed: Double?
    let netIncomePerEBT: Double?
    let ebtPerEbit: Double?
    let ebitPerRevenue: Double?
    let debtRatio: Double?
    let debtEquityRatio: Double?
    let longTermDebtToCapitalization: Double?
    let totalDebtToCapitalization: Double?
    let interestCoverage: Double?
    let cashFlowToDebtRatio: Double?
    let companyEquityMultiplier: Double?
    let receivablesTurnover: Double?
    let payablesTurnover: Double?
    let inventoryTurnover: Double?
    let fixedAssetTurnover: Double?
    let assetTurnover: Double?
    let operatingCashFlowPerShare: Double?
    let freeCashFlowPerShare: Double?
    let cashPerShare: Double?
    let payoutRatio: Double?
    let operatingCashFlowSalesRatio: Double?
    let freeCashFlowOperatingCashFlowRatio: Double?
    let cashFlowCoverageRatios: Double?
    let shortTermCoverageRatios: Double?
    let capitalExpenditureCoverageRatio: Double?
    let dividendPaidAndCapexCoverageRatio: Double?
    let dividendPayoutRatio: Double?
    let priceBookValueRatio: Double?
    let priceToBookRatio: Double?
    let priceToSalesRatio: Double?
    let priceEarningsRatio: Double?
    let priceToFreeCashFlowsRatio: Double?
    let priceToOperatingCashFlowsRatio: Double?
    let priceCashFlowRatio: Double?
    let priceEarningsToGrowthRatio: Double?
    let priceSalesRatio: Double?
    let dividendYield: Double?
    let enterpriseValueMultiple: Double?
    let priceFairValue: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        currentRatio = dict["currentRatio"].double
        quickRatio = dict["quickRatio"].double
        cashRatio = dict["cashRatio"].double
        daysOfSalesOutstanding = dict["daysOfSalesOutstanding"].double
        daysOfInventoryOutstanding = dict["daysOfInventoryOutstanding"].double
        operatingCycle = dict["operatingCycle"].double
        daysOfPayablesOutstanding = dict["daysOfPayablesOutstanding"].double
        cashConversionCycle = dict["cashConversionCycle"].double
        grossProfitMargin = dict["grossProfitMargin"].double
        operatingProfitMargin = dict["operatingProfitMargin"].double
        pretaxProfitMargin = dict["pretaxProfitMargin"].double
        netProfitMargin = dict["netProfitMargin"].double
        effectiveTaxRate = dict["effectiveTaxRate"].double
        returnOnAssets = dict["returnOnAssets"].double
        returnOnEquity = dict["returnOnEquity"].double
        returnOnCapitalEmployed = dict["returnOnCapitalEmployed"].double
        netIncomePerEBT = dict["netIncomePerEBT"].double
        ebtPerEbit = dict["ebtPerEbit"].double
        ebitPerRevenue = dict["ebitPerRevenue"].double
        debtRatio = dict["debtRatio"].double
        debtEquityRatio = dict["debtEquityRatio"].double
        longTermDebtToCapitalization = dict["longTermDebtToCapitalization"].double
        totalDebtToCapitalization = dict["totalDebtToCapitalization"].double
        interestCoverage = dict["interestCoverage"].double
        cashFlowToDebtRatio = dict["cashFlowToDebtRatio"].double
        companyEquityMultiplier = dict["companyEquityMultiplier"].double
        receivablesTurnover = dict["receivablesTurnover"].double
        payablesTurnover = dict["payablesTurnover"].double
        inventoryTurnover = dict["inventoryTurnover"].double
        fixedAssetTurnover = dict["fixedAssetTurnover"].double
        assetTurnover = dict["assetTurnover"].double
        operatingCashFlowPerShare = dict["operatingCashFlowPerShare"].double
        freeCashFlowPerShare = dict["freeCashFlowPerShare"].double
        cashPerShare = dict["cashPerShare"].double
        payoutRatio = dict["payoutRatio"].double
        operatingCashFlowSalesRatio = dict["operatingCashFlowSalesRatio"].double
        freeCashFlowOperatingCashFlowRatio = dict["freeCashFlowOperatingCashFlowRatio"].double
        cashFlowCoverageRatios = dict["cashFlowCoverageRatios"].double
        shortTermCoverageRatios = dict["shortTermCoverageRatios"].double
        capitalExpenditureCoverageRatio = dict["capitalExpenditureCoverageRatio"].double
        dividendPaidAndCapexCoverageRatio = dict["dividendPaidAndCapexCoverageRatio"].double
        dividendPayoutRatio = dict["dividendPayoutRatio"].double
        priceBookValueRatio = dict["priceBookValueRatio"].double
        priceToBookRatio = dict["priceToBookRatio"].double
        priceToSalesRatio = dict["priceToSalesRatio"].double
        priceEarningsRatio = dict["priceEarningsRatio"].double
        priceToFreeCashFlowsRatio = dict["priceToFreeCashFlowsRatio"].double
        priceToOperatingCashFlowsRatio = dict["priceToOperatingCashFlowsRatio"].double
        priceCashFlowRatio = dict["priceCashFlowRatio"].double
        priceEarningsToGrowthRatio = dict["priceEarningsToGrowthRatio"].double
        priceSalesRatio = dict["priceSalesRatio"].double
        dividendYield = dict["dividendYield"].double
        enterpriseValueMultiple = dict["enterpriseValueMultiple"].double
        priceFairValue = dict["priceFairValue"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Current Ratio",
                      key: "currentRatio",
                      value: currentRatio),
            StockData(name: "Cash Ratio",
                      key: "cashRatio",
                      value: cashRatio),
            StockData(name: "Operating Profit Margin",
                      key: "operatingProfitMargin",
                      value: operatingProfitMargin),
            StockData(name: "Net Profit Margin",
                      key: "netProfitMargin",
                      value: netProfitMargin),
            StockData(name: "Cash Flow to Debt Ratio",
                      key: "cashFlowToDebtRatio",
                      value: cashFlowToDebtRatio),
            StockData(name: "Return on Capital Employed",
                      key: "returnOnCapitalEmployed",
                      value: returnOnCapitalEmployed),
            StockData(name: "Debt Ratio",
                      key: "debtRatio",
                      value: debtRatio),
            StockData(name: "Dividend Payout Ratio",
                      key: "dividendPayoutRatio",
                      value: dividendPayoutRatio),
            StockData(name: "Interest Coverage",
                      key: "interestCoverage",
                      value: interestCoverage),
            StockData(name: "Quick Ratio",
                      key: "quickRatio",
                      value: quickRatio),
            StockData(name: "Effective Tax Rate",
                      key: "effectiveTaxRate",
                      value: effectiveTaxRate),
            StockData(name: "Days of Sales Outstanding",
                      key: "daysOfSalesOutstanding",
                      value: daysOfSalesOutstanding),
            StockData(name: "Days of Inventory Outstanding",
                      key: "daysOfInventoryOutstanding",
                      value: daysOfInventoryOutstanding),
            StockData(name: "Operating Cycle",
                      key: "operatingCycle",
                      value: operatingCycle),
            StockData(name: "Days of Payables Outstanding",
                      key: "daysOfPayablesOutstanding",
                      value: daysOfPayablesOutstanding),
            StockData(name: "Cash Conversion Cycle",
                      key: "cashConversionCycle",
                      value: cashConversionCycle),
            StockData(name: "Gross Profit Margin",
                      key: "grossProfitMargin",
                      value: grossProfitMargin),

            StockData(name: "Pretax Profit Margin",
                      key: "pretaxProfitMargin",
                      value: pretaxProfitMargin),

            StockData(name: "Return On Assets",
                      key: "returnOnAssets",
                      value: returnOnAssets),
            StockData(name: "Return On Equity",
                      key: "returnOnEquity",
                      value: returnOnEquity),

            StockData(name: "Net Income Per EBT",
                      key: "netIncomePerEBT",
                      value: netIncomePerEBT),
            StockData(name: "EBT Per EBIT",
                      key: "ebtPerEbit",
                      value: ebtPerEbit),
            StockData(name: "EBIT Per Revenue",
                      key: "ebitPerRevenue",
                      value: ebitPerRevenue),
            StockData(name: "Debt Equity Ratio",
                      key: "debtEquityRatio",
                      value: debtEquityRatio),
            StockData(name: "Long Term Debt to Capitalization",
                      key: "longTermDebtToCapitalization",
                      value: longTermDebtToCapitalization),
            StockData(name: "Total Debt to Capitalization",
                      key: "totalDebtToCapitalization",
                      value: totalDebtToCapitalization),
            StockData(name: "Company Equity Multiplier",
                      key: "companyEquityMultiplier",
                      value: companyEquityMultiplier),
            StockData(name: "Receivables Turnover",
                      key: "receivablesTurnover",
                      value: receivablesTurnover),
            StockData(name: "Payables Turnover",
                      key: "payablesTurnover",
                      value: payablesTurnover),
            StockData(name: "Inventory Turnover",
                      key: "inventoryTurnover",
                      value: inventoryTurnover),
            StockData(name: "Fixed Asset Turnover",
                      key: "fixedAssetTurnover",
                      value: fixedAssetTurnover),
            StockData(name: "Asset Turnover",
                      key: "assetTurnover",
                      value: assetTurnover),
            StockData(name: "Operating Cash Flow Per Share",
                      key: "operatingCashFlowPerShare",
                      value: operatingCashFlowPerShare),
            StockData(name: "Free Cash Flow Per Share",
                      key: "freeCashFlowPerShare",
                      value: freeCashFlowPerShare),
            StockData(name: "Cash Per Share",
                      key: "cashPerShare",
                      value: cashPerShare),
            StockData(name: "Payout Ratio",
                      key: "payoutRatio",
                      value: payoutRatio),
            StockData(name: "Operating Cash Flow Sales Ratio",
                      key: "operatingCashFlowSalesRatio",
                      value: operatingCashFlowSalesRatio),
            StockData(name: "Free Cash Flow Operating Cash Flow Ratio",
                      key: "freeCashFlowOperatingCashFlowRatio",
                      value: freeCashFlowOperatingCashFlowRatio),
            StockData(name: "Cash Flow Coverage Ratios",
                      key: "cashFlowCoverageRatios",
                      value: cashFlowCoverageRatios),
            StockData(name: "Short Term Coverage Ratios",
                      key: "shortTermCoverageRatios",
                      value: shortTermCoverageRatios),
            StockData(name: "Capital Expenditure Coverage Ratio",
                      key: "capitalExpenditureCoverageRatio",
                      value: capitalExpenditureCoverageRatio),
            StockData(name: "Dividend Paid and Capex Coverage Ratio",
                      key: "dividendPaidAndCapexCoverageRatio",
                      value: dividendPaidAndCapexCoverageRatio),

            StockData(name: "Price Book Value Ratio",
                      key: "priceBookValueRatio",
                      value: priceBookValueRatio),
            StockData(name: "Price to Book Ratio",
                      key: "priceToBookRatio",
                      value: priceToBookRatio),
            StockData(name: "Price to Sales Ratio",
                      key: "priceToSalesRatio",
                      value: priceToSalesRatio),
            StockData(name: "Price Earnings Ratio",
                      key: "priceEarningsRatio",
                      value: priceEarningsRatio),
            StockData(name: "Price to Free Cash Flows Ratio",
                      key: "priceToFreeCashFlowsRatio",
                      value: priceToFreeCashFlowsRatio),
            StockData(name: "Price to Operating Cash Flows Ratio",
                      key: "priceToOperatingCashFlowsRatio",
                      value: priceToOperatingCashFlowsRatio),
            StockData(name: "Price Cash Flow Ratio",
                      key: "priceCashFlowRatio",
                      value: priceCashFlowRatio),
            StockData(name: "Price Earnings to Growth Ratio",
                      key: "priceEarningsToGrowthRatio",
                      value: priceEarningsToGrowthRatio),
            StockData(name: "Price Sales Ratio",
                      key: "priceSalesRatio",
                      value: priceSalesRatio),
            StockData(name: "Dividend Yield",
                      key: "dividendYield",
                      value: dividendYield),
            StockData(name: "Enterprise Value Multiple",
                      key: "enterpriseValueMultiple",
                      value: enterpriseValueMultiple),
            StockData(name: "Price Fair Value",
                      key: "priceFairValue",
                      value: priceFairValue),
        ]
    }
}
