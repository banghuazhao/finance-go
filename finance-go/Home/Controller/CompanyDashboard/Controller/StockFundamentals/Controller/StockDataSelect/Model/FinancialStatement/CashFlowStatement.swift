//
//  CashFlowStatement.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class CashFlowStatement: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let netIncome: Double?
    let depreciationAndAmortization: Double?
    let deferredIncomeTax: Double?
    let stockBasedCompensation: Double?
    let changeInWorkingCapital: Double?
    let accountsReceivables: Double?
    let inventory: Double?
    let accountsPayables: Double?
    let otherWorkingCapital: Double?
    let otherNonCashItems: Double?
    let netCashProvidedByOperatingActivities: Double?
    let investmentsInPropertyPlantAndEquipment: Double?
    let acquisitionsNet: Double?
    let purchasesOfInvestments: Double?
    let salesMaturitiesOfInvestments: Double?
    let otherInvestingActivites: Double?
    let netCashUsedForInvestingActivites: Double?
    let debtRepayment: Double?
    let commonStockIssued: Double?
    let commonStockRepurchased: Double?
    let dividendsPaid: Double?
    let otherFinancingActivites: Double?
    let netCashUsedProvidedByFinancingActivities: Double?
    let effectOfForexChangesOnCash: Double?
    let netChangeInCash: Double?
    let cashAtEndOfPeriod: Double?
    let cashAtBeginningOfPeriod: Double?
    let operatingCashFlow: Double?
    let capitalExpenditure: Double?
    let freeCashFlow: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        netIncome = dict["netIncome"].double
        depreciationAndAmortization = dict["depreciationAndAmortization"].double
        deferredIncomeTax = dict["deferredIncomeTax"].double
        stockBasedCompensation = dict["stockBasedCompensation"].double
        changeInWorkingCapital = dict["changeInWorkingCapital"].double
        accountsReceivables = dict["accountsReceivables"].double
        inventory = dict["inventory"].double
        accountsPayables = dict["accountsPayables"].double
        otherWorkingCapital = dict["otherWorkingCapital"].double
        otherNonCashItems = dict["otherNonCashItems"].double
        netCashProvidedByOperatingActivities = dict["netCashProvidedByOperatingActivities"].double
        investmentsInPropertyPlantAndEquipment = dict["investmentsInPropertyPlantAndEquipment"].double
        acquisitionsNet = dict["acquisitionsNet"].double
        purchasesOfInvestments = dict["purchasesOfInvestments"].double
        salesMaturitiesOfInvestments = dict["salesMaturitiesOfInvestments"].double
        otherInvestingActivites = dict["otherInvestingActivites"].double
        netCashUsedForInvestingActivites = dict["netCashUsedForInvestingActivites"].double
        debtRepayment = dict["debtRepayment"].double
        commonStockIssued = dict["commonStockIssued"].double
        commonStockRepurchased = dict["commonStockRepurchased"].double
        dividendsPaid = dict["dividendsPaid"].double
        otherFinancingActivites = dict["otherFinancingActivites"].double
        netCashUsedProvidedByFinancingActivities = dict["netCashUsedProvidedByFinancingActivities"].double
        effectOfForexChangesOnCash = dict["effectOfForexChangesOnCash"].double
        netChangeInCash = dict["netChangeInCash"].double
        cashAtEndOfPeriod = dict["cashAtEndOfPeriod"].double
        cashAtBeginningOfPeriod = dict["cashAtBeginningOfPeriod"].double
        operatingCashFlow = dict["operatingCashFlow"].double
        capitalExpenditure = dict["capitalExpenditure"].double
        freeCashFlow = dict["freeCashFlow"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Net Income",
                              key: "netIncome",
                              value: netIncome),
            StockData(name: "Depreciation and Amortization",
                              key: "depreciationAndAmortization",
                              value: depreciationAndAmortization),
            StockData(name: "Deferred Income Tax",
                              key: "deferredIncomeTax",
                              value: deferredIncomeTax),
            StockData(name: "Stock Based Compensation",
                              key: "stockBasedCompensation",
                              value: stockBasedCompensation),
            StockData(name: "Change in Working Capital",
                              key: "changeInWorkingCapital",
                              value: changeInWorkingCapital),
            StockData(name: "Accounts Receivables",
                              key: "accountsReceivables",
                              value: accountsReceivables),
            StockData(name: "Inventory",
                              key: "inventory",
                              value: inventory),
            StockData(name: "Accounts Payables",
                              key: "accountsPayables",
                              value: accountsPayables),
            StockData(name: "Other Working Capital",
                              key: "otherWorkingCapital",
                              value: otherWorkingCapital),
            StockData(name: "Other NonCash Items",
                              key: "otherNonCashItems",
                              value: otherNonCashItems),
            StockData(name: "Net Cash Provided by Operating Activities",
                              key: "netCashProvidedByOperatingActivities",
                              value: netCashProvidedByOperatingActivities),
            StockData(name: "Investments in Property Plant and Equipment",
                              key: "investmentsInPropertyPlantAndEquipment",
                              value: investmentsInPropertyPlantAndEquipment),
            StockData(name: "Acquisitions Net",
                              key: "acquisitionsNet",
                              value: acquisitionsNet),
            StockData(name: "Purchases of Investments",
                              key: "purchasesOfInvestments",
                              value: purchasesOfInvestments),
            StockData(name: "Sales Maturities of Investments",
                              key: "salesMaturitiesOfInvestments",
                              value: salesMaturitiesOfInvestments),
            StockData(name: "Other Investing Activities",
                              key: "otherInvestingActivites",
                              value: otherInvestingActivites),
            StockData(name: "Net Cash Used for Investing Activities",
                              key: "netCashUsedForInvestingActivites",
                              value: netCashUsedForInvestingActivites),
            StockData(name: "Debt Repayment",
                              key: "debtRepayment",
                              value: debtRepayment),
            StockData(name: "Common Stock Issued",
                              key: "commonStockIssued",
                              value: commonStockIssued),
            StockData(name: "Common Stock Repurchased",
                              key: "commonStockRepurchased",
                              value: commonStockRepurchased),
            StockData(name: "Dividends Paid",
                              key: "dividendsPaid",
                              value: dividendsPaid),
            StockData(name: "Other Financing Activities",
                              key: "otherFinancingActivites",
                              value: otherFinancingActivites),
            StockData(name: "Net Cash Used Provided by Financing Activities",
                              key: "netCashUsedProvidedByFinancingActivities",
                              value: netCashUsedProvidedByFinancingActivities),
            StockData(name: "Effect of Forex Changes On Cash",
                              key: "effectOfForexChangesOnCash",
                              value: effectOfForexChangesOnCash),
            StockData(name: "Net Change in Cash",
                              key: "netChangeInCash",
                              value: netChangeInCash),
            StockData(name: "Cash at End of Period",
                              key: "cashAtEndOfPeriod",
                              value: cashAtEndOfPeriod),
            StockData(name: "Cash at Beginning of Period",
                              key: "cashAtBeginningOfPeriod",
                              value: cashAtBeginningOfPeriod),
            StockData(name: "Operating Cash Flow",
                              key: "operatingCashFlow",
                              value: operatingCashFlow),
            StockData(name: "Capital Expenditure",
                              key: "capitalExpenditure",
                              value: capitalExpenditure),
            StockData(name: "Free Cash Flow",
                              key: "freeCashFlow",
                              value: freeCashFlow),
        ]
    }
}
