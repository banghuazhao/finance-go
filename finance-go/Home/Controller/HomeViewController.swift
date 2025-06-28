//
//  HomeViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/6.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import JXSegmentedView
import UIKit

class HomeItem {
    let title: String
    let viewController: UIViewController
    init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}

class HomeViewController: FGUIViewController {
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    override var isStaticBackground: Bool {
        return true
    }

    lazy var searchBar = UISearchBar().then { searchBar in
        searchBar.barStyle = .black
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(tapSearchBar))
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.addGestureRecognizer(tapGestureRecognizer)
            searchBar.searchTextField.delegate = self
            searchBar.searchTextField.layer.borderColor = UIColor.white.cgColor
            searchBar.searchTextField.layer.borderWidth = 0.5
            searchBar.searchTextField.layer.cornerRadius = 10
            searchBar.searchTextField.textColor = UIColor.white1
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Comapny/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
            searchBar.searchTextField.leftView?.tintColor = UIColor.white2
        } else {
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchField.addGestureRecognizer(tapGestureRecognizer)
                searchField.delegate = self
                searchField.layer.borderColor = UIColor.white.cgColor
                searchField.layer.borderWidth = 0.5
                searchField.layer.cornerRadius = 10
                searchField.textColor = UIColor.white1
                searchField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Company/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
                searchField.leftView?.tintColor = UIColor.white2
            }
        }
    }

    lazy var homeItems = [
        HomeItem(
            title: "Watchlist".localized(),
            viewController: {
                let vc = WatchlistViewController()
                return vc
            }()
        ),
        HomeItem(
            title: "Stocks".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .stock
                return vc
            }()
        ),
        HomeItem(
            title: "Most Actives".localized(),
            viewController: {
                let vc = MostCompaniesViewController()
                vc.mostType = .active
                return vc
            }()
        ),
        HomeItem(
            title: "Gainers".localized(),
            viewController: {
                let vc = MostCompaniesViewController()
                vc.mostType = .gainer
                return vc
            }()
        ),

        HomeItem(
            title: "Losers".localized(),
            viewController: {
                let vc = MostCompaniesViewController()
                vc.mostType = .loser
                return vc
            }()
        ),
        HomeItem(
            title: "Indexes".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .index
                return vc
            }()
        ),
        HomeItem(
            title: "Crypto".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .cryptocurrency
                return vc
            }()
        ),
        HomeItem(
            title: "Futures".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .future
                return vc
            }()
        ),
        HomeItem(
            title: "Funds".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .fund
                return vc
            }()
        ),
        HomeItem(
            title: "ETF".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .etf
                return vc
            }()
        ),
        HomeItem(
            title: "Forex".localized(),
            viewController: {
                let vc = CompaniesViewController()
                vc.valueType = .forex
                return vc
            }()
        ),
    ]

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home".localized()

        navigationItem.titleView = searchBar

//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_search"), style: .plain, target: self, action: #selector(beginSearching(_:)))

        setupSegmentedView()
    }

    fileprivate func setupSegmentedView() {
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.backgroundColor = .navBarColor
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-5)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.titles = homeItems.map { $0.title }
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

extension HomeViewController {
    @objc func tapSearchBar() {
        searchBar.resignFirstResponder()
        let companiesSearchViewController = CompaniesSearchViewController()
        companiesSearchViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(companiesSearchViewController, animated: true)
    }
}

// MARK: - JXSegmentedViewDelegate

extension HomeViewController: JXSegmentedViewDelegate {
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

extension HomeViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return homeItems[index].viewController as! JXSegmentedListContainerViewListDelegate
    }
}

// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
