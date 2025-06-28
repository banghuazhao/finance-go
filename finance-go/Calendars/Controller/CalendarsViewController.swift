//
//  CalendarsViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/5.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

class CalendarsViewController: FGUIViewController {
    var statusBarCoverView = UIView()
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendars".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_more"), style: .plain, target: self, action: #selector(showMore(_:)))

        view.addSubview(statusBarCoverView)
        statusBarCoverView.backgroundColor = .navBarColor
        statusBarCoverView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.topbarHeight + 40)
        }

        setupSegmentedView()
    }

    fileprivate func setupSegmentedView() {
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.backgroundColor = .navBarColor
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let titles = ["Earning".localized(), "IPO".localized(), "Stock Split".localized(), "Dividend".localized(), "Economic".localized()]
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

// MARK: - actions

extension CalendarsViewController {
    @objc func showMore(_ sender: UIBarButtonItem) {
        if segmentedView.selectedIndex == 0 {
            let allEarningCalendarViewController = AllEarningCalendarViewController()
            allEarningCalendarViewController.hidesBottomBarWhenPushed = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(allEarningCalendarViewController, animated: true)
        } else if segmentedView.selectedIndex == 1 {
            let allIPOCalendarViewController = AllIPOCalendarViewController()
            allIPOCalendarViewController.hidesBottomBarWhenPushed = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(allIPOCalendarViewController, animated: true)
        } else if segmentedView.selectedIndex == 2 {
            let allStockSplitCalendarViewController = AllStockSplitCalendarViewController()
            allStockSplitCalendarViewController.hidesBottomBarWhenPushed = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(allStockSplitCalendarViewController, animated: true)
        } else if segmentedView.selectedIndex == 3 {
            let allDividendCalendarViewController = AllDividendCalendarViewController()
            allDividendCalendarViewController.hidesBottomBarWhenPushed = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(allDividendCalendarViewController, animated: true)
        } else if segmentedView.selectedIndex == 4 {
            let allEconomicCalendarViewController = AllEconomicCalendarViewController()
            allEconomicCalendarViewController.hidesBottomBarWhenPushed = true
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(allEconomicCalendarViewController, animated: true)
        }
    }
}

// MARK: - JXSegmentedViewDelegate

extension CalendarsViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据
            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
    }
}

extension CalendarsViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return EarningCalendarViewController()
        } else if index == 1 {
            return IPOCalendarViewController()
        } else if index == 2 {
            return StockSplitCalendarViewController()
        } else if index == 3 {
            return DividendCalendarViewController()
        } else {
            return EconomicCalendarViewController()
        }
    }
}
