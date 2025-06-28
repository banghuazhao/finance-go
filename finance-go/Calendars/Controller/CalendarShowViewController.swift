//
//  CalendarShowViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import SwiftyJSON
import UIKit

class CalendarShowViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var calendar: FGCalendar!
    var company: Company?

    var storage: Storage<String, Data>? {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(name: Constants.cacheFolderName, expiry: .date(Date().addingTimeInterval(5)), directory: Constants.cacheDirectory),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }

    var cacheKey: String {
        guard let symbol = company?.symbol else { return "https://financialmodelingprep.com/api/v3/quote/AAPL" }
        return "https://financialmodelingprep.com/api/v3/quote/\(symbol)"
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(EarningCalendarCell.self, forCellReuseIdentifier: "EarningCalendarCell")
        tv.register(IPOCalendarCell.self, forCellReuseIdentifier: "IPOCalendarCell")
        tv.register(StockSplitCalendarCell.self, forCellReuseIdentifier: "StockSplitCalendarCell")
        tv.register(DividendCalendarCell.self, forCellReuseIdentifier: "DividendCalendarCell")
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earning Calendar".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview()
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

        switch calendar {
        case is EarningCalendar:
            title = "Earning Calendar".localized()
        case is IPOCalendar:
            title = "IPO Calendar".localized()
        case is StockSplitCalendar:
            title = "Stock Split Calendar".localized()
        default:
            title = "Dividend Calendar".localized()
        }

        company = CompanyStore.shared.item(symbol: calendar.symbol)

        if company != nil {
            fetchData()
        }
    }
}

// MARK: - methods

extension CalendarShowViewController {
    private func fetchData() {
        if let data = try? storage?.object(forKey: cacheKey) {
            setData(data: data)
            if let expire = try? storage?.isExpiredObject(forKey: cacheKey), expire == true {
                fetchDataOnline()
            }
        } else {
            fetchDataOnline()
        }
    }

    @objc private func fetchDataOnline() {
        let parameters = ["apikey": Constants.APIKey]
        AF.request(cacheKey, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                try? self.storage?.setObject(data, forKey: self.cacheKey)
                self.setData(data: data)
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    func setData(data: Data) {
        let json = JSON(data)
        for value in json.arrayValue {
            if let symbol = value["symbol"].string {
                CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - actions

extension CalendarShowViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        guard let company = company else { return }
        var str: String = ""
        var fileName: String = ""

        str += "\("Company Symbol".localized()): \(calendar.symbol)"

        str += "\n"

        str += "\("Company Name".localized()): \(company.name)"

        str += "\n"

        str += "\("Date".localized()): \(calendar.date)"

        str += "\n"

        if let earningCalendar = calendar as? EarningCalendar {
            if let eps = earningCalendar.eps {
                str += "EPS: \(convertDoubleToCurrency(amount: eps, localeIdentifier: company.localeIdentifier))"
            } else {
                str += "EPS: \("Not Available".localized())"
            }

            str += "\n"

            if let epsEstimated = earningCalendar.epsEstimated {
                str += "EPS Estimated: \(convertDoubleToCurrency(amount: epsEstimated, localeIdentifier: company.localeIdentifier))"
            } else {
                str += "EPS Estimated: \("Not Available".localized())"
            }

            str += "\n"

            let time = earningCalendar.time
            if time == "bmo" {
                str += "\("Time".localized()): \("Before Market Open".localized())"
            } else if time == "amc" {
                str += "\("Time".localized()): \("After Market Close".localized())"
            } else {
                str += "\("Time".localized()): \(time)"
            }

            str += "\n"

            if let revenue = earningCalendar.revenue {
                str += "\("RevenueTrue".localized()): \(convertDoubleToCurrency(amount: revenue, localeIdentifier: company.localeIdentifier))"
            } else {
                str += "\("RevenueTrue".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let revenueEstimated = earningCalendar.revenueEstimated {
                str += "\("Revenue Estimated".localized()): \(convertDoubleToCurrency(amount: revenueEstimated, localeIdentifier: company.localeIdentifier))"
            } else {
                str += "\("Revenue Estimated".localized()): \("Not Available".localized())"
            }
            fileName = "\("Earning Calendar".localized()) \(earningCalendar.symbol) \(earningCalendar.date).txt"
        } else if let iPOCalendar = calendar as? IPOCalendar {
            str += "\("Exchange".localized()): \(iPOCalendar.exchange)"

            str += "\n"

            str += "Actions: \(iPOCalendar.actions)"

            str += "\n"

            if let shares = iPOCalendar.shares {
                str += "\("Shares".localized()): \(shares)"
            } else {
                str += "\("Shares".localized()): \("Not Available".localized())"
            }

            str += "\n"

            str += "\("Price Range".localized()): \(iPOCalendar.priceRange)"

            str += "\n"

            if let marketCap = iPOCalendar.marketCap {
                str += "\("Market Cap".localized()): \(convertDoubleToCurrency(amount: marketCap, localeIdentifier: company.localeIdentifier))"
            } else {
                str += "\("Market Cap".localized()): \("Not Available".localized())"
            }

            fileName = "\("IPO Calendar".localized()) \(iPOCalendar.symbol) \(iPOCalendar.date).txt"
        } else if let stockSplitCalendar = calendar as? StockSplitCalendar {
            if let numerator = stockSplitCalendar.numerator {
                str += "\("Numerator".localized()): \(convertDoubleToDecimal(amount: numerator))"
            } else {
                str += "\("Numerator".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let denominator = stockSplitCalendar.denominator {
                str += "\("Denominator".localized()): \(convertDoubleToDecimal(amount: denominator))"
            } else {
                str += "\("Denominator".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let numerator = stockSplitCalendar.numerator, let denominator = stockSplitCalendar.denominator {
                str += "\("Stock Split Ratio".localized()): \(convertDoubleToDecimal(amount: denominator))-for-\(convertDoubleToDecimal(amount: numerator))"
            } else {
                str += "\("Stock Split Ratio".localized()): \("Not Available".localized())"
            }

            fileName = "\("Stock Split Calendar".localized()) \(stockSplitCalendar.symbol) \(stockSplitCalendar.date).txt"
        } else if let dividendCalendar = calendar as? DividendCalendar {
            if let adjDividend = dividendCalendar.adjDividend {
                str += "\("Adjust Dividend".localized()): \(convertDoubleToCurrency(amount: adjDividend, companySymbol: dividendCalendar.symbol))"
            } else {
                str += "\("Adjust Dividend".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let dividend = dividendCalendar.dividend {
                str += "\("Dividend".localized()): \(convertDoubleToCurrency(amount: dividend, companySymbol: dividendCalendar.symbol))"
            } else {
                str += "\("Dividend".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let recordDate = dividendCalendar.recordDate {
                str += "\("Record Date".localized()): \(recordDate)"
            } else {
                str += "\("Record Date".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let paymentDate = dividendCalendar.paymentDate {
                str += "\("Payment Date".localized()): \(paymentDate)"
            } else {
                str += "\("Payment Date".localized()): \("Not Available".localized())"
            }

            str += "\n"

            if let declarationDate = dividendCalendar.declarationDate {
                str += "\("Declaration Date".localized()): \(declarationDate)"
            } else {
                str += "\("Declaration Date".localized()): \("Not Available".localized())"
            }

            fileName = "\("Dividend Calendar".localized()) \(dividendCalendar.symbol) \(dividendCalendar.date).txt"
        }

        let file = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create share file: \(err)")
        }

        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = (sender.value(forKey: "view") as? UIView)?.bounds ?? .zero
            popoverController.sourceView = sender.value(forKey: "view") as? UIView
        }

        activityVC.completionWithItemsHandler = { (_, completed: Bool, _: [Any]?, error: Error?) in
            if completed {
                if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                    print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
                } else {
                    #if !targetEnvironment(macCatalyst)
                        GADInterstitialAd.load(withAdUnitID: Constants.GoogleAdsID.interstitialAdID, request: GADRequest()) { ad, error in
                            if let error = error {
                                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                return
                            }
                            if let ad = ad {
                                ad.present(fromRootViewController: UIApplication.getTopMostViewController() ?? self)
                                InterstitialAdsRequestHelper.resetRequestCount()
                            } else {
                                print("interstitial Ad wasn't ready")
                            }
                        }
                    #endif
                }
            } else {
                print("UIAlertController not completed")
            }
        }

        present(activityVC, animated: true, completion: {
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                #if targetEnvironment(macCatalyst)
                    let moreAppsViewController = MoreAppsViewController()
                    moreAppsViewController.isAds = true
                    (UIApplication.getTopMostViewController() ?? self).present(FGUINavigationController(rootViewController: moreAppsViewController), animated: true, completion: nil)
                #endif
            }
        })
    }
}

extension CalendarShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if company != nil {
            return 2
        } else {
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            switch calendar {
            case is EarningCalendar:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCalendarCell", for: indexPath) as! EarningCalendarCell
                cell.earningCalendar = calendar as? EarningCalendar
                return cell
            case is IPOCalendar:
                let cell = tableView.dequeueReusableCell(withIdentifier: "IPOCalendarCell", for: indexPath) as! IPOCalendarCell
                cell.iPOCalendar = calendar as? IPOCalendar
                return cell
            case is StockSplitCalendar:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StockSplitCalendarCell", for: indexPath) as! StockSplitCalendarCell
                cell.stockSplitCalendar = calendar as? StockSplitCalendar
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DividendCalendarCell", for: indexPath) as! DividendCalendarCell
                cell.dividendCalendar = calendar as? DividendCalendar
                return cell
            }
        }

        if company != nil && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
            cell.company = company
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if company != nil && indexPath.row == 1 {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = company
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }
}
