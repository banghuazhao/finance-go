//
//  FinancialTerms.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

enum FinancialTermCategory: String, CaseIterable {
    case all = "All"
    case financialStatement = "Financial Statements"
    case financialRatio = "Financial Ratios"
}

struct FinancialTerm {
    let name: String
    let category: FinancialTermCategory
}

struct FinancialTermStore {
    static let shared = FinancialTermStore()
    let items: [FinancialTerm] = [
        FinancialTerm(name: "Revenue", category: .financialStatement),
        FinancialTerm(name: "Net Income", category: .financialStatement),
        FinancialTerm(name: "Operating Income", category: .financialStatement),
        FinancialTerm(name: "EBIT", category: .financialStatement),
        FinancialTerm(name: "Interest Expense", category: .financialStatement),
        FinancialTerm(name: "Income Tax Expense", category: .financialStatement),
        FinancialTerm(name: "Cash and Cash Equivalents", category: .financialStatement),
        FinancialTerm(name: "Short-term Debt", category: .financialStatement),
        FinancialTerm(name: "Long-term Debt", category: .financialStatement),
        FinancialTerm(name: "Total Assets", category: .financialStatement),
        FinancialTerm(name: "Total Current Assets", category: .financialStatement),
        FinancialTerm(name: "Total Current Liabilities", category: .financialStatement),
        FinancialTerm(name: "Total Shareholders Equity", category: .financialStatement),
        FinancialTerm(name: "Operating Cash Flow", category: .financialStatement),
        FinancialTerm(name: "Dividend Payments", category: .financialStatement),
        FinancialTerm(name: "Short-term Investments", category: .financialStatement),
        FinancialTerm(name: "Receivables", category: .financialStatement),
        FinancialTerm(name: "Free Cash Flow", category: .financialStatement),
        FinancialTerm(name: "Total Liabilities", category: .financialStatement),
        FinancialTerm(name: "Current Ratio", category: .financialRatio),
        FinancialTerm(name: "Cash Ratio", category: .financialRatio),
        FinancialTerm(name: "Debt Ratio", category: .financialRatio),
        FinancialTerm(name: "Interest Coverage", category: .financialRatio),
        FinancialTerm(name: "Operating Profit Margin", category: .financialRatio),
        FinancialTerm(name: "Net Profit Margin", category: .financialRatio),
        FinancialTerm(name: "Return on Equity", category: .financialRatio),
        FinancialTerm(name: "Dividend Payout Ratio", category: .financialRatio),
        FinancialTerm(name: "Return on Debt", category: .financialRatio),
        FinancialTerm(name: "Cash Flow to Debt Ratio", category: .financialRatio),
        FinancialTerm(name: "CFROI", category: .financialRatio),
        FinancialTerm(name: "Return on Invested Capital", category: .financialRatio),
        FinancialTerm(name: "Acid-Test Ratio", category: .financialRatio),
        FinancialTerm(name: "Debt Equity Ratio", category: .financialRatio),
        FinancialTerm(name: "Equity Ratio", category: .financialRatio),
        FinancialTerm(name: "Return on Capital Employed", category: .financialRatio),
        FinancialTerm(name: "Free Cash Flow-To-Sales", category: .financialRatio),
        FinancialTerm(name: "Retention Ratio", category: .financialRatio),
        FinancialTerm(name: "Debt to Equity", category: .financialRatio),
    ]

    func getAll(sorted: Bool = true, filterIndex: Int) -> [FinancialTerm] {
        var filteredItems = items
        let financialTermCategory = FinancialTermCategory.allCases[filterIndex]
        if financialTermCategory != .all {
            filteredItems = filteredItems.filter { (filterItem) -> Bool in
                filterItem.category == financialTermCategory
            }
        }
        if sorted {
            return filteredItems.sorted { (ft1, ft2) -> Bool in
                ft1.name < ft2.name
            }
        } else {
            return filteredItems
        }
    }
}

let financialTermsDict: [String: String] = [
    "Revenue":
        "In accounting, revenue is the income that a business has from its normal business activities, usually from the sale of goods and services to customers.\n\nReference: https://en.wikipedia.org/wiki/Revenue"
    ,
    "Net Income":
        "In business and accounting, net income is a measure of the profitability of a venture. It is an entity's income minus cost of goods sold, expenses (e.g., SG&A), depreciation and amortization, interest, and taxes for an accounting period.\n\nReference: https://en.wikipedia.org/wiki/Net_income"
    ,
    "Operating Income":
        "Operating income is an accounting figure that measures the amount of profit realized from a business's operations, after deducting operating expenses such as wages, depreciation, and cost of goods sold (COGS).\n\nReference: https://www.investopedia.com/terms/o/operatingincome.asp"
    ,
    "EBIT":
        "In accounting and finance, earnings before interest and taxes (EBIT) is a measure of a firm's profit that includes all incomes and expenses (operating and non-operating) except interest expenses and income tax expenses.\n\nEBIT = Net income + Interest + Taxes\n\nReference: https://en.wikipedia.org/wiki/Earnings_before_interest_and_taxes"
    ,
    "Interest Expense":
        "Interest expense relates to the cost of borrowing money. It is the price that a lender charges a borrower for the use of the lender's money.\n\nReference: https://en.wikipedia.org/wiki/Interest_expense"
    ,
    "Income Tax Expense":
        "Income tax expense is the amount of expense that a business recognizes in an accounting period for the government tax related to its taxable profit.\n\nReference: https://www.accountingtools.com/articles/2017/5/12/income-tax-expense"
    ,
    "Cash and Cash Equivalents":
        "Cash and cash equivalents refers to the line item on the balance sheet that reports the value of a company's assets that are cash or can be converted into cash immediately.\n\nReference: https://www.investopedia.com/terms/c/cashandcashequivalents.asp"
    ,
    "Short-term Debt":
        "Short term debt, also called current liabilities, is a firm's financial obligations that are expected to be paid off within a year.\n\nReference: https://www.investopedia.com/terms/s/shorttermdebt.asp"
    ,
    "Long-term Debt":
        "Long-term debt is debt that matures in more than one year.\n\nReference: https://www.investopedia.com/terms/l/longtermdebt.asp"
    ,
    "Total Assets":
        "Total assets refers to the total amount of assets owned by a person or entity. Assets are items of economic value, which are expended over time to yield a benefit for the owner.\n\nReference: https://www.accountingtools.com/articles/2017/5/15/total-assets"
    ,
    "Total Current Assets":
        "Total current assets is the aggregate amount of all cash, receivables, prepaid expenses, and inventory on an organization's balance sheet. These assets are classified as current assets if there is an expectation that they will be converted into cash within one year.\n\nReference: https://www.accountingtools.com/articles/2017/5/15/total-current-assets"
    ,
    "Total Current Liabilities":
        "Also called Current Liabilities and listed on the Balance Sheet, they are a company's short-term financial obligations that are due within one year or within a normal operating cycle.\n\nReference: https://www.investopedia.com/terms/c/currentliabilities.asp"
    ,
    "Total Shareholders Equity":
        "Total Shareholder equity, also referred to as shareholders' equity and stockholders' equity, is a corporation's owners' residual claim after debts have been paid. Equity is equal to a firm's total assets minus its total liabilities.\n\nReference: https://www.investopedia.com/terms/s/shareholdersequity.asp"
    ,
    "Operating Cash Flow":
        "Operating cash flow is a measure of the amount of cash generated by a company's normal business operations.\n\nReference: https://www.investopedia.com/terms/o/operatingcashflow.asp"
    ,
    "Dividend Payments":
        "A dividend is a payment made by a corporation to its shareholders, usually as a distribution of profits. When a corporation earns a profit or surplus, the corporation is able to re-invest the profit in the business (called retained earnings) and pay a proportion of the profit as a dividend to shareholders.\n\nReference: https://en.wikipedia.org/wiki/Dividend",
    "Short-term Investments":
        "Short Term investments usually include CDs, money market accounts, high-yield savings accounts, government bonds and Treasury bills which can be easily converted into cash in the next three to twelve months.\n\nReference:https://www.investopedia.com/terms/s/shorterminvestments.asp",
    "Receivables":
        "Receivables are debts owed to a company by its customers for goods or services that have been delivered or used but not yet paid for.\n\nReference:https://www.investopedia.com/terms/r/receivables.asp",
    "Free Cash Flow":
        "Free cash flow represents the cash a company generates after cash outflows to support operations and maintain its capital assets.\n\nReference:https://www.investopedia.com/terms/f/freecashflow.asp",
    "Total Liabilities":
        "Total liabilities are the combined debts and obligations that a company owes to outside parties.\n\nReference:https://www.investopedia.com/terms/t/total-liabilities.asp",
    "Current Ratio":
        "The current ratio is a liquidity ratio that measures a company's ability to pay short-term obligations or those due within one year.\n\nCurrent Ratio = Total Current assets / Total Current liabilities\n\nReference: https://www.investopedia.com/terms/c/currentratio.asp"
    ,
    "Cash Ratio":
        "The cash ratio is a measurement of a company's liquidity, specifically the ratio of a company's total cash and cash equivalents to its current liabilities.\n\nCash Ratio = Cash and Cash Equivalents / Total Current liabilities\n\nReference: https://www.investopedia.com/terms/c/cash-ratio.asp"
    ,
    "Debt Ratio":
        "The debt ratio is a financial ratio that measures the extent of a company’s leverage.\n\nDebt ratio = (Short-term Debt + Long-term Debt) / Total assets\n\nReference: https://www.investopedia.com/terms/d/debtratio.asp"
    ,
    "Interest Coverage":
        "The interest coverage ratio is a debt ratio and profitability ratio used to determine how easily a company can pay interest on its outstanding debt.\n\nInterest Coverage Ratio = EBIT / Interest Expense\n\nReference: https://www.investopedia.com/terms/i/interestcoverageratio.asp"
    ,
    "Operating Profit Margin":
        "The operating margin measures how much profit a company makes on a dollar of sales, after paying for variable costs of production, such as wages and raw materials, but before paying interest or tax.\n\nOperating Profit Margin = Operating Income / Revenue\n\nReference: https://www.investopedia.com/terms/o/operatingmargin.asp"
    ,
    "Net Profit Margin":
        "The net profit margin is equal to how much net income or profit is generated as a percentage of revenue.\n\nNet Profit Margin = Net Income / Revenue\n\nReference: https://www.investopedia.com/terms/n/net_margin.asp"
    ,
    "Return on Equity":
        "Return on equity (ROE) is a measure of financial performance calculated by dividing net income by shareholders' equity.\n\nReturn on Equity = Net Income / Total Shareholders Equity\n\nReference: https://www.investopedia.com/terms/r/returnonequity.asp"
    ,
    "Dividend Payout Ratio":
        "The dividend payout ratio is the ratio of the total amount of dividends paid out to shareholders relative to the net income of the company.\n\nDividend Payout Ratio = |Dividend Payments / Net Income|\n\nReference: https://www.investopedia.com/terms/d/dividendpayoutratio.asp"
    ,
    "Return on Debt":
        "Return on debt (ROD) is a measure of profitability with respect to a firm's leverage.\n\nReturn on Debt = Net Income / Long-term Debt\n\nReference: https://www.investopedia.com/terms/r/return-on-debt.asp"
    ,
    "Cash Flow to Debt Ratio":
        "The cash flow-to-debt ratio is the ratio of a company’s cash flow from operations to its total debt.\n\nCash Flow to Debt Ratio = Operating Cash Flow / (Short-term Debt + Long-term Debt)\n\nReference: https://www.investopedia.com/terms/c/cash-flowtodebt-ratio.asp"
    ,
    "CFROI":
        "Cash Flow Return on Investment (CFROI) is defined as the average economic return on all of a company's investment projects in a given year\n\nCFROI = Operating Cash Flow / (Total Assets -Total Current Liabilities)\n\nReference: https://www.investopedia.com/terms/c/cfroi.asp",
    "Return on Invested Capital":
        "Return on invested capital is a calculation used to assess a company's efficiency at allocating the capital under its control to profitable investments.\n\nReturn on Invested Capital = (Operating Income - Income Tax Expense) / (long-term Debt + Total Shareholders Equity - Cash and Cash Equivalents)\n\nReference: https://www.investopedia.com/terms/r/returnoninvestmentcapital.asp",
    "Acid-Test Ratio":
        "The acid-test ratio also measures the liquidity of a company by measuring how well its current assets could cover its current liabilities. However, the Acid-Test Ratio is a more conservative measure of liquidity because it doesn't include all of the items used in the current ratio.\n\nAcid-Test Ratio = (Cash and Cash Equivalents + Short-term Investments + Receivables) / Total Current Liabilities\n\nReference: https://www.investopedia.com/terms/a/acidtest.asp",
    "Debt Equity Ratio":
        "It is a measure of the degree to which a company is financing its operations through debt versus wholly-owned funds.\n\nDebt Equity Ratio = Total Liabilities / Total Shareholders Equity\n\nReference: https://www.investopedia.com/terms/d/debtequityratio.asp",
    "Equity Ratio":
        "The shareholder equity ratio shows how much of the company's assets are funded by equity shares. The lower the ratio result, the more debt a company has used to pay for its.\n\nShareholder Equity Ratio = Total Shareholder Equity / Total Assets\n\nReference: https://www.investopedia.com/terms/s/shareholderequityratio.asp",
    "Return on Capital Employed":
        "Return on capital employed (ROCE) is a financial ratio that measures a company's profitability and the efficiency with which its capital is used. In other words, the ratio measures how well a company is generating profits from its capital.\n\nReturn on Capital Employed = Operating Income / (Total Assets - Total Current Liabilities)\n\nReference: https://www.investopedia.com/terms/r/roce.asp",
    "Free Cash Flow-To-Sales":
        "Free cash flow-to-revenue is a performance ratio that measures operating cash flows after deduction of capital expenditures relative to sales (revenue).\n\nFree Cash Flow-To-Sales = Free Cash Flow / Revenue\n\nReference: https://www.investopedia.com/terms/f/free-cash-flow-to-sales.asp",
    "Retention Ratio":
        "The retention ratio is the proportion of earnings kept back in the business as retained earnings.\n\nRetention Ratio = (Net Income - |Dividend Payments|) / Net Income\n\nReference: https://www.investopedia.com/terms/r/retentionratio.asp",
    "Debt to Equity": "Long Term Debt / totalStockHolderEquity"
]
