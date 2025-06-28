//
//  IncomeStatement.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class IncomeStatement: Financial {
    var symbol: String
    var date: String
    var peroid: String
    let revenue: Double?
    let costOfRevenue: Double?
    let grossProfit: Double?
    let grossProfitRatio: Double?
    let researchAndDevelopmentExpenses: Double?
    let generalAndAdministrativeExpenses: Double?
    let sellingAndMarketingExpenses: Double?
    let otherExpenses: Double?
    let operatingExpenses: Double?
    let costAndExpenses: Double?
    let interestExpense: Double?
    let depreciationAndAmortization: Double?
    let ebitda: Double?
    let ebitdaratio: Double?
    let operatingIncome: Double?
    let operatingIncomeRatio: Double?
    let totalOtherIncomeExpensesNet: Double?
    let incomeBeforeTax: Double?
    let incomeBeforeTaxRatio: Double?
    let incomeTaxExpense: Double?
    let netIncome: Double?
    let netIncomeRatio: Double?
    let eps: Double?

    required init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        peroid = dict["peroid"].stringValue
        revenue = dict["revenue"].double
        costOfRevenue = dict["costOfRevenue"].double
        grossProfit = dict["grossProfit"].double
        grossProfitRatio = dict["grossProfitRatio"].double
        researchAndDevelopmentExpenses = dict["researchAndDevelopmentExpenses"].double
        generalAndAdministrativeExpenses = dict["generalAndAdministrativeExpenses"].double
        sellingAndMarketingExpenses = dict["sellingAndMarketingExpenses"].double
        otherExpenses = dict["otherExpenses"].double
        operatingExpenses = dict["operatingExpenses"].double
        costAndExpenses = dict["costAndExpenses"].double
        interestExpense = dict["interestExpense"].double
        depreciationAndAmortization = dict["depreciationAndAmortization"].double
        ebitda = dict["ebitda"].double
        ebitdaratio = dict["ebitdaratio"].double
        operatingIncome = dict["operatingIncome"].double
        operatingIncomeRatio = dict["operatingIncomeRatio"].double
        totalOtherIncomeExpensesNet = dict["totalOtherIncomeExpensesNet"].double
        incomeBeforeTax = dict["incomeBeforeTax"].double
        incomeBeforeTaxRatio = dict["incomeBeforeTaxRatio"].double
        incomeTaxExpense = dict["incomeTaxExpense"].double
        netIncome = dict["netIncome"].double
        netIncomeRatio = dict["netIncomeRatio"].double
        eps = dict["eps"].double
    }

    func createStockDatas() -> [StockData] {
        return [
            StockData(name: "Revenue",
                      key: "revenue",
                      value: revenue),
            StockData(name: "Cost of Revenue",
                      key: "costOfRevenue",
                      value: costOfRevenue),
            StockData(name: "Gross Profit",
                      key: "grossProfit",
                      value: grossProfit),
            StockData(name: "Gross Profit Ratio",
                      key: "grossProfitRatio",
                      value: grossProfitRatio),
            StockData(name: "Research and Development Expenses",
                      key: "researchAndDevelopmentExpenses",
                      value: researchAndDevelopmentExpenses),
            StockData(name: "General and Administrative Expenses",
                      key: "generalAndAdministrativeExpenses",
                      value: generalAndAdministrativeExpenses),
            StockData(name: "Selling and Marketing Expenses",
                      key: "sellingAndMarketingExpenses",
                      value: sellingAndMarketingExpenses),
            StockData(name: "Other Expenses",
                      key: "otherExpenses",
                      value: otherExpenses),
            StockData(name: "Operating Expenses",
                      key: "operatingExpenses",
                      value: operatingExpenses),
            StockData(name: "Cost and Expenses",
                      key: "costAndExpenses",
                      value: costAndExpenses),
            StockData(name: "Interest Expense",
                      key: "interestExpense",
                      value: interestExpense),
            StockData(name: "Depreciation and Amortization",
                      key: "depreciationAndAmortization",
                      value: depreciationAndAmortization),
            StockData(name: "EBITDA",
                      key: "ebitda",
                      value: ebitda),
            StockData(name: "EBITDA Ratio",
                      key: "ebitdaratio",
                      value: ebitdaratio),
            StockData(name: "Operating Income",
                      key: "operatingIncome",
                      value: operatingIncome),
            StockData(name: "Operating Income Ratio",
                      key: "operatingIncomeRatio",
                      value: operatingIncomeRatio),
            StockData(name: "Total Other Income Expenses (Net)",
                      key: "totalOtherIncomeExpensesNet",
                      value: totalOtherIncomeExpensesNet),
            StockData(name: "Income Before Tax",
                      key: "incomeBeforeTax",
                      value: incomeBeforeTax),
            StockData(name: "Income Before Tax Ratio",
                      key: "incomeBeforeTaxRatio",
                      value: incomeBeforeTaxRatio),
            StockData(name: "Income Tax Expense",
                      key: "incomeTaxExpense",
                      value: incomeTaxExpense),
            StockData(name: "Net Income",
                      key: "netIncome",
                      value: netIncome),
            StockData(name: "Net Income Ratio",
                      key: "netIncomeRatio",
                      value: netIncomeRatio),
            StockData(name: "EPS",
                      key: "eps",
                      value: eps),
        ]
    }
}
