//
//  StockDataSelectViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import JXSegmentedView
import MJRefresh
import SwiftyJSON
import UIKit

class StockDataSelectViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company?

    var financialBase: FinancialBase?

    lazy var dataSource: [Any] = [
        "Quarterly".localized(),
        StockDataSelect(
            name: "Single Quarter".localized(),
            image: UIImage(named: "icon_data_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseSingleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .quarterly
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "4 Consecutive Quarters".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMultipleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .quarterly
                vc.numberOfDatas = 4
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "8 Consecutive Quarters".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMultipleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .quarterly
                vc.numberOfDatas = 8
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "All Fiscal Quarters".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMaxViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .quarterly
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        "Annually".localized(),
        StockDataSelect(
            name: "Single Year".localized(),
            image: UIImage(named: "icon_data_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseSingleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .annually
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "4 Consecutive Years".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMultipleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .annually
                vc.numberOfDatas = 4
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "8 Consecutive Years".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMultipleViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .annually
                vc.numberOfDatas = 8
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        StockDataSelect(
            name: "All Fiscal Years".localized(),
            image: UIImage(named: "icon_line_chart"),
            action: { [weak self] in
                guard let self = self else { return }
                let vc = FinancialBaseMaxViewController()
                vc.company = self.company
                vc.financialBase = self.financialBase
                vc.fiscalYearType = .annually
                self.navigationController?.pushViewController(vc, animated: true)
            }),
    ]

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(RowTitleHeader.self, forCellReuseIdentifier: "RowTitleHeader")
        tv.register(StockDataSelectCell.self, forCellReuseIdentifier: "StockDataSelectCell")
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.separatorColor = .white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        title = financialBase?.name.localized()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
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
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StockDataSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let object = dataSource[indexPath.row] as? StockDataSelect {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockDataSelectCell", for: indexPath) as! StockDataSelectCell
            cell.stockDataSelect = object
            return cell
        } else if let object = dataSource[indexPath.row] as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RowTitleHeader", for: indexPath) as! RowTitleHeader
            cell.titleText = object
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let object = dataSource[indexPath.row] as? StockDataSelect {
            object.action?()
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension StockDataSelectViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
