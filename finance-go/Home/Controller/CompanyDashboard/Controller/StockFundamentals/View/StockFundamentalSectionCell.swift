//
//  StockFundamentalSectionCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class StockFundamentalSectionCell: UITableViewCell {
    var company: Company? {
        didSet {
            guard let company = company else { return }
            if [ValueType.stock, .etf, .fund].contains(company.type) {
                companyDashboardItems = [financialStatements, financialRatios, enterpriseValues, keyMetrices, financialGrowth, companyRating, discountedCashFlow,
                                         earningCallTranscript, stockInsiderTrading, holders, upgradesAndDowngrades, earningCalendar]
            } else if ["^GSPC", "^DJI", "^IXIC"].contains(company.symbol) {
                majorIndexListCompany.title = MajorIndexListCompanies.indexListDict[company.symbol] ?? ""
                companyDashboardItems = [majorIndexListCompany]
            } else {
                companyDashboardItems = []
            }

            collectionView.reloadData()
            collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionView.collectionViewLayout.collectionViewContentSize.height)
            }
            collectionView.reloadData()
        }
    }

    var companyDashboardItems: [CompanyDashboardItem] = [CompanyDashboardItem]()

    lazy var financialStatements = CompanyDashboardItem(
        title: "Financial Statements".localized(),
        icon: UIImage(named: "financial_statement"),
        action: { [weak self] in
            guard let self = self else { return }
            let financialStatementViewController = FinancialStatementViewController()
            financialStatementViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(financialStatementViewController, animated: true)
        })
    lazy var financialRatios = CompanyDashboardItem(
        title: "Financial Ratios".localized(),
        icon: UIImage(named: "financial_ratio"),
        action: { [weak self] in
            guard let self = self else { return }
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = self.company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Financial Ratios",
                endPoint: "ratios",
                financial: FinancialRatio.self)
            self.parentViewController?.navigationController?.pushViewController(stockDataSelectViewController, animated: true)
        })
    lazy var enterpriseValues = CompanyDashboardItem(
        title: "Enterprise Values".localized(),
        icon: UIImage(named: "company_value"),
        action: { [weak self] in
            guard let self = self else { return }

            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = self.company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Enterprise Values",
                endPoint: "enterprise-values",
                financial: EnterpriseValue.self)
            self.parentViewController?.navigationController?.pushViewController(stockDataSelectViewController, animated: true)
        })
    lazy var keyMetrices = CompanyDashboardItem(
        title: "Key Metrics".localized(),
        icon: UIImage(named: "key_metrics"),
        action: { [weak self] in
            guard let self = self else { return }
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = self.company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Key Metrix",
                endPoint: "key-metrics",
                financial: KeyMetrix.self)
            self.parentViewController?.navigationController?.pushViewController(stockDataSelectViewController, animated: true)
        })
    lazy var financialGrowth = CompanyDashboardItem(
        title: "Financial Growth".localized(),
        icon: UIImage(named: "company_growth"),
        action: { [weak self] in
            guard let self = self else { return }
            let stockDataSelectViewController = StockDataSelectViewController()
            stockDataSelectViewController.company = self.company
            stockDataSelectViewController.financialBase = FinancialBase(
                name: "Financial Growth",
                endPoint: "financial-growth",
                financial: FinancialGrowth.self)
            self.parentViewController?.navigationController?.pushViewController(stockDataSelectViewController, animated: true)
        })
    lazy var companyRating = CompanyDashboardItem(
        title: "Company Rating".localized(),
        icon: UIImage(named: "icon_rateStar"),
        action: { [weak self] in
            guard let self = self else { return }
            let companyRatingViewController = CompanyRatingViewController()
            companyRatingViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(companyRatingViewController, animated: true)
        })
    lazy var discountedCashFlow = CompanyDashboardItem(
        title: "Discounted Cash Flow".localized(),
        icon: UIImage(named: "icon_list_bullet"),
        action: { [weak self] in
            guard let self = self else { return }
            let dCFViewController = DCFViewController()
            dCFViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(dCFViewController, animated: true)
        })
    lazy var earningCallTranscript = CompanyDashboardItem(
        title: "Earning Call Transcript".localized(),
        icon: UIImage(named: "icon_docQuote"),
        action: { [weak self] in
            guard let self = self else { return }
            let earningCallTranscript = EarningCallTranscriptListViewController()
            earningCallTranscript.company = self.company
            self.parentViewController?.navigationController?.pushViewController(earningCallTranscript, animated: true)
        })
    lazy var stockInsiderTrading = CompanyDashboardItem(
        title: "Stock Insider Trading".localized(),
        icon: UIImage(named: "icon_briefCase"),
        action: { [weak self] in
            guard let self = self else { return }
            let stockInsiderTradingViewController = StockInsiderTradingViewController()
            stockInsiderTradingViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(stockInsiderTradingViewController, animated: true)
        })
    lazy var holders = CompanyDashboardItem(
        title: "Holders".localized(),
        icon: UIImage(named: "holder"),
        action: { [weak self] in
            guard let self = self else { return }
            let holderViewController = HolderViewController()
            holderViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(holderViewController, animated: true)
        })
    lazy var upgradesAndDowngrades = CompanyDashboardItem(
        title: "Upgrades & Downgrades".localized(),
        icon: UIImage(named: "icon_arrow_up_right"),
        action: { [weak self] in
            guard let self = self else { return }
            let stockGradeViewController = StockGradeViewController()
            stockGradeViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(stockGradeViewController, animated: true)
        })
    lazy var majorIndexListCompany = CompanyDashboardItem(
        title: "".localized(),
        icon: UIImage(named: "company_value"),
        action: { [weak self] in
            guard let self = self else { return }
            let majorIndexListCompanies = MajorIndexListCompanies()
            majorIndexListCompanies.index = self.company
            self.parentViewController?.navigationController?.pushViewController(majorIndexListCompanies, animated: true)
        })
    lazy var earningCalendar = CompanyDashboardItem(
        title: "Historical Calendar".localized(),
        icon: UIImage(named: "calendars"),
        action: { [weak self] in
            guard let self = self else { return }
            let historicalCalendarViewController = HistoricalCalendarViewController()
            historicalCalendarViewController.company = self.company
            self.parentViewController?.navigationController?.pushViewController(historicalCalendarViewController, animated: true)
        })

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CompanyDashboardItemCell.self, forCellWithReuseIdentifier: "CompanyDashboardItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.bottom.equalToSuperview().inset(10)
        }

        setupItems()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StockFundamentalSectionCell {
    private func setupItems() {
        companyDashboardItems = [financialStatements, financialRatios, enterpriseValues, keyMetrices, financialGrowth, companyRating, discountedCashFlow,
                                 earningCallTranscript, stockInsiderTrading, holders, upgradesAndDowngrades, earningCalendar]
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension StockFundamentalSectionCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companyDashboardItems.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyDashboardItemCell", for: indexPath) as! CompanyDashboardItemCell
        cell.companyDashboardItem = companyDashboardItems[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let aciton = companyDashboardItems[indexPath.row].action {
            aciton()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StockFundamentalSectionCell: UICollectionViewDelegateFlowLayout {
    // 定义每一个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let leftInset = 20
        if Constants.Device.isIphone {
            let width = (contentView.bounds.width - 20 * 2 - 16 * 2) / 3 - 1
            return CGSize(width: width, height: 112)
        } else {
            return CGSize(width: 144, height: 112)
        }
    }

    // 定义每个Section的四边间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 16, right: 20)
    }

    // 两行cell之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    // 两列cell之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
