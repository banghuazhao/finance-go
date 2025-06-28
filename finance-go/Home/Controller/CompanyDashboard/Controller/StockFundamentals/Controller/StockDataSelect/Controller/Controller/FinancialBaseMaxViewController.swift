//
//  FinancialBaseMaxViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Hue
import Localize_Swift
import MJRefresh
import SnapKit
import SnapshotKit
import SwiftyJSON
import Then
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class FinancialBaseMaxViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    enum FiscalYearType {
        case quarterly
        case annually
    }

    var fiscalYearType: FiscalYearType = .quarterly

    var company: Company?

    var financialBase: FinancialBase?

    var currentStockDatas = [[StockData]]()

    var financials = [Financial]()

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width:
            view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        title = financialBase?.name.localized()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                view.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.width.equalToSuperview()
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                    make.centerX.equalToSuperview()
                }
            }
        #endif
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - methods

extension FinancialBaseMaxViewController {
    @objc private func fetchDataOnline() {
        guard let company = company, let financialBase = financialBase else { return }
        startFetchData()
        let urlString = APIManager.baseURL + "/api/v3/\(financialBase.endPoint)/\(company.symbol)"
        var paraters = [String: String]()
        if fiscalYearType == .quarterly {
            paraters = ["period": "quarter", "apikey": Constants.APIKey]
        } else {
            paraters = ["apikey": Constants.APIKey]
        }
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: paraters,
            cacheExpire: .date(Date().addingTimeInterval(24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var temps = [Financial]()
                    for value in json.arrayValue {
                        temps.append(financialBase.financial.init(dict: value))
                    }
                    self.financials = temps
                    self.setupDataSource()
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.financials.count == 0 {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.financials.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }

    func setupDataSource() {
        currentStockDatas = [[StockData]]()
        for financial in financials {
            for (ro, stockData) in financial.createStockDatas().enumerated() {
                if currentStockDatas.count == ro {
                    currentStockDatas.append([stockData])
                } else {
                    currentStockDatas[ro] += [stockData]
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FinancialBaseMaxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financials.count > 0 ? currentStockDatas.count : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StockDataMaxCell(style: .default, reuseIdentifier: "StockDataMaxCell\(indexPath.row)")
        cell.company = company
        cell.financials = financials
        cell.stockDatas = currentStockDatas[indexPath.row]
        return cell
    }
}
