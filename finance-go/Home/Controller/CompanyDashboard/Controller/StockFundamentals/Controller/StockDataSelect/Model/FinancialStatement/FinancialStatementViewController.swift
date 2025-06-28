//
//  FinancialStatementViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

class FinancialStatementViewController: FGUIViewController {
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    override var isStaticBackground: Bool {
        return true
    }

    var company: Company?

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Financial Statements".localized()

        setupSegmentedView()
    }

    fileprivate func setupSegmentedView() {
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.backgroundColor = .navBarColor
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let titles = ["Income".localized(), "Balance Sheet".localized(), "Cash Flow".localized()]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.titles = titles
        titleDataSource.titleNormalColor = UIColor.white1.alpha(0.7)
        titleDataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        titleDataSource.titleSelectedColor = UIColor.white1
        titleDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 17)
        segmentedDataSource = titleDataSource
        segmentedView.dataSource = titleDataSource

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = UIColor.white1
        segmentedView.indicators = [indicator]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - JXSegmentedViewDelegate

extension FinancialStatementViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据
            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
    }
}

// MARK: - JXSegmentedListContainerViewDataSource

extension FinancialStatementViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Income Statement",
                endPoint: "income-statement",
                financial: IncomeStatement.self)
            return stockDataSelectViewController
        } else if index == 1 {
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Balance Sheet Statement",
                endPoint: "balance-sheet-statement",
                financial: BalanceSheetStatement.self)
            return stockDataSelectViewController
        } else {
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Cash Flow Statement",
                endPoint: "cash-flow-statement",
                financial: CashFlowStatement.self)
            return stockDataSelectViewController
        }
    }
}
