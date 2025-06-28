//
//  StockPeersViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/24.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import MJRefresh
import SnapKit
import SwiftyJSON
import Then
import UIKit

class StockPeersViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var stockPeers = [Company]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height:
            8))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height:
            80))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false
    }

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Stock Peers".localized()

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

        fetchStockPeersQuote(stockPeers: stockPeers)
    }
}

// MARK: - methods

extension StockPeersViewController {
    private func fetchStockPeersQuote(stockPeers: [Company]) {
        guard stockPeers.count > 0 else { return }
        let companySymbols = stockPeers.map { $0.symbol }
        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }
        let urlString = APIManager.baseURL + "/api/v3/quote/\(quaryPara)"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(10)),
            fetchType: .cacheOrOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    for value in json.arrayValue {
                        if let symbol = value["symbol"].string {
                            CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
                        }
                    }
                } completion: {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StockPeersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockPeers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        cell.company = stockPeers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDashboardViewController = CompanyDashboardViewController()
        companyDashboardViewController.hidesBottomBarWhenPushed = true
        companyDashboardViewController.company = stockPeers[indexPath.row]
        navigationController?.pushViewController(companyDashboardViewController, animated: true)
    }
}
