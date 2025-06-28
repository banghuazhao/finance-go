//
//  StockQuotesViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/19.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import UIKit

class StockQuotesViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company? {
        didSet {
            if let symbol = company?.symbol, let companyQuote = company?.companyQuote {
                title = symbol
                twoColumnTitleValues = [
                    TwoColumnTitleValue(
                        title1: "Open".localized(),
                        value1: companyQuote.open?.decimalString ?? "-",
                        title2: "Volume".localized(),
                        value2: companyQuote.volume?.decimalString ?? "-"),
                    TwoColumnTitleValue(
                        title1: "Day High".localized(),
                        value1: companyQuote.dayHigh?.decimalString ?? "-",
                        title2: "Average Volume".localized(),
                        value2: companyQuote.avgVolume?.decimalString ?? "-"),
                    TwoColumnTitleValue(
                        title1: "Day Low".localized(),
                        value1: companyQuote.dayLow?.decimalString ?? "-",
                        title2: "Market Cap".localized(),
                        value2: companyQuote.marketCap?.decimalString ?? "-"),
                    TwoColumnTitleValue(
                        title1: "Year High".localized(),
                        value1: companyQuote.yearHigh?.decimalString ?? "-",
                        title2: "P/E Ratio".localized(),
                        value2: companyQuote.pe?.decimalString ?? "-"),
                    TwoColumnTitleValue(
                        title1: "Year Low".localized(),
                        value1: companyQuote.yearLow?.decimalString ?? "-",
                        title2: "EPS".localized(),
                        value2: companyQuote.eps?.decimalString ?? "-"),
                    TwoColumnTitleValue(
                        title1: "50-Day Moving Avg".localized(),
                        value1: companyQuote.priceAvg50?.decimalString ?? "-",
                        title2: "200-Day Moving Avg".localized(),
                        value2: companyQuote.priceAvg200?.decimalString ?? "-")]
                tableView.reloadData()
            }
        }
    }

    var twoColumnTitleValues = [
        TwoColumnTitleValue(
            title1: "Open".localized(),
            value1: "-",
            title2: "Volume".localized(),
            value2: "-"),
        TwoColumnTitleValue(
            title1: "Day High".localized(),
            value1: "-",
            title2: "Average Volume".localized(),
            value2: "-"),
        TwoColumnTitleValue(
            title1: "Day Low".localized(),
            value1: "-",
            title2: "Market Cap".localized(),
            value2: "-"),
        TwoColumnTitleValue(
            title1: "Year Hight".localized(),
            value1: "-",
            title2: "P/E Ratio".localized(),
            value2: "-"),
        TwoColumnTitleValue(
            title1: "Year Low".localized(),
            value1: "-",
            title2: "EPS",
            value2: "-"),
        TwoColumnTitleValue(
            title1: "50-Day Moving Avg".localized(),
            value1: "-",
            title2: "200-Day Moving Avg".localized(),
            value2: "-")]

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(TwoColumnTitleValueCell.self, forCellReuseIdentifier: "TwoColumnTitleValueCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
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

extension StockQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoColumnTitleValues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoColumnTitleValueCell", for: indexPath) as! TwoColumnTitleValueCell
        cell.twoColumnTitleValue = twoColumnTitleValues[indexPath.row]
        return cell
    }
}
