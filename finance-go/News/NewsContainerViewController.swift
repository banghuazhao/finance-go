//
//  NewsContainerViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/9/30.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

class NewsContainerViewController: FGUIViewController {
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

        setupSegmentedView()
    }

    fileprivate func setupSegmentedView() {
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let titles = ["Stock News".localized(), "Articles".localized(), "Crypto News".localized(), "Forex News".localized()]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.titles = titles
        titleDataSource.titleNormalColor = UIColor.white1.alpha(0.7)
        titleDataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        titleDataSource.titleSelectedColor = UIColor.white1
        titleDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 17)
        segmentedDataSource = titleDataSource

        segmentedView.dataSource = titleDataSource
        segmentedView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        navigationItem.titleView = segmentedView

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorColor = UIColor.white1
        segmentedView.indicators = [indicator]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 处于第一个item的时候，才允许屏幕边缘手势返回
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension NewsContainerViewController {
}

extension NewsContainerViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据
            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

//        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension NewsContainerViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return StockNewsViewController()
        } else if index == 1 {
            return ArticleViewController()
        } else if index == 2{
            let vc = OtherNewsViewController()
            vc.newsType = "crypto_news"
            return vc
        } else {
            let vc = OtherNewsViewController()
            vc.newsType = "forex_news"
            return vc
        }
    }
}
