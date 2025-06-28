//
//  FinancialBaseSingleViewController.swift
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
import SwiftyJSON
import Then
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class FinancialBaseSingleViewController: FGUIViewController {
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

    var compare: Bool {
        guard let financialBase = financialBase else { return true }
        return FiscalPeriodCompareHelper.getCompare(financialBase: financialBase)
    }

    var currentIndex: Int = 0
    var previousIndex: Int {
        if fiscalYearType == .quarterly {
            return currentIndex + 4
        } else {
            return currentIndex + 1
        }
    }

    var currentFinancial: Financial?
    var previousFinancial: Financial?

    var currentStockDatas = [StockData]()
    var previousStockDatas = [StockData?]()

    var financials = [Financial]()

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(StockDataSingleCell.self, forCellReuseIdentifier: "StockDataSingleCell")
        tv.register(StockDataSingleHeaderCell.self, forHeaderFooterViewReuseIdentifier: "StockDataSingleHeaderCell")
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let viewWithTag = tableView.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
            tableView.addTopBounceAreaView(color: .navBarColor)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        title = financialBase?.name.localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

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

        tableView.addTopBounceAreaView(color: .navBarColor)

        tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - actions

extension FinancialBaseSingleViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        print("FinancialBaseSingleViewController share")

        guard let company = company, currentStockDatas.count > 0, let currentFinancial = currentFinancial, let financialBase = financialBase else { return }

        var str: String = ""

        str += company.symbol + "\n\n"

        str += financialBase.name.localized() + "\t" + currentFinancial.date + "\n"

        for currentStockData in currentStockDatas {
            var valueString = "No Data".localized()
            if let value = currentStockData.value {
                if currentStockData.dataType == .decimal {
                    valueString = value.convertToCurrency(localeIdentifier: company.localeIdentifier)
                } else if currentStockData.dataType == .decimal {
                    valueString = value.convertToVariableDigitsDecimal()
                } else {
                    valueString = (value * 100).decimalTwoDigitsString + "%"
                }
            }
            str += "\(currentStockData.name):\t\(valueString)\n"
        }

        let file = getDocumentsDirectory().appendingPathComponent("\(financialBase.name.localized()) \(company.symbol) \(currentFinancial.date).txt")

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create Company Profile.txt: \(err)")
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

// MARK: - methods

extension FinancialBaseSingleViewController {
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
        if financials.count > 0 {
            currentFinancial = financials[currentIndex]
            currentStockDatas = financials[currentIndex].createStockDatas()
            if compare {
                if financials.count > previousIndex {
                    previousFinancial = financials[previousIndex]
                    previousStockDatas = financials[previousIndex].createStockDatas()
                } else {
                    previousFinancial = nil
                    previousStockDatas = Array(repeating: nil, count: currentStockDatas.count)
                }
            } else {
                previousFinancial = nil
                previousStockDatas = Array(repeating: nil, count: currentStockDatas.count)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FinancialBaseSingleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financials.count > 0 ? currentStockDatas.count : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StockDataSingleHeaderCell") as! StockDataSingleHeaderCell
        headerView.compare = compare
        headerView.previousFinancial = previousFinancial
        headerView.currentFinancial = currentFinancial

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDateSelectTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        headerView.addGestureRecognizer(tapRecognizer)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockDataSingleCell", for: indexPath) as! StockDataSingleCell
        cell.company = company
        cell.compare = compare
        cell.previousStockData = previousStockDatas[indexPath.row]
        cell.stockData = currentStockDatas[indexPath.row]
        return cell
    }

    @objc private func handleDateSelectTap() {
        let stockDataDatesViewController = StockDataDatesViewController()
        stockDataDatesViewController.financialBase = financialBase
        stockDataDatesViewController.currentIndex = currentIndex
        if fiscalYearType == .quarterly {
            stockDataDatesViewController.numberOfDatas = 4
        } else {
            stockDataDatesViewController.numberOfDatas = 1
        }
        stockDataDatesViewController.financials = financials
        stockDataDatesViewController.delegate = self
        navigationController?.pushViewController(stockDataDatesViewController, animated: true)
    }
}

extension FinancialBaseSingleViewController: StockDataDatesViewControllerDelegate {
    func handleDateSelected(selectedIndex: Int) {
        currentIndex = selectedIndex
        setupDataSource()
        tableView.reloadData()
    }
}
