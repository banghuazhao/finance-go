//
//  MajorIndexListCompanies.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/7.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import Localize_Swift
import MJRefresh
import Schedule
import SnapKit
import SwiftyJSON
import Then
import UIKit

class MajorIndexListCompanies: FGUIViewController {
    static let indexListDict = [
        "^GSPC": "S&P 500 Companies".localized(),
        "^DJI": "Dow Jones Companies".localized(),
        "^IXIC": "Nasdaq 100 Companies".localized(),
    ]

    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var index: Company?

    var companies: [Company] = [Company]()

    var searchCompanies: [Company] = [Company]()
    var searchText: String = "" {
        didSet {
            if searchText == "" {
                isSearching = false
            } else {
                isSearching = true
            }
        }
    }

    var isSearching: Bool = false

    lazy var searchController: UISearchController = {
        if #available(iOS 13.0, *) {
            let searchController = UISearchController().then { sc in
                sc.searchBar.delegate = self
                sc.searchBar.barStyle = .black

                sc.searchBar.searchTextField.layer.borderColor = UIColor.white.cgColor
                sc.searchBar.searchTextField.layer.borderWidth = 0.5
                sc.searchBar.searchTextField.layer.cornerRadius = 10
                sc.searchBar.searchTextField.textColor = UIColor.white1
                sc.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Comapny/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
                sc.searchBar.searchTextField.leftView?.tintColor = UIColor.white2
            }
            return searchController
        } else {
            var searchController = UISearchController(searchResultsController: nil).then { sc in
                sc.searchBar.delegate = self
                sc.searchBar.barStyle = .black
                if let searchField = sc.searchBar.value(forKey: "searchField") as? UITextField {
                    searchField.layer.borderColor = UIColor.white.cgColor
                    searchField.layer.borderWidth = 0.5
                    searchField.layer.cornerRadius = 10
                    searchField.textColor = UIColor.white1
                    searchField.backgroundColor = .clear
                    searchField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Comapny/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
                    searchField.leftView?.tintColor = UIColor.white2
                }
            }
            return searchController
        }
    }()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        tv.delaysContentTouches = false
        tv.keyboardDismissMode = .onDrag

        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    var taskFetchQuotes: Task?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskFetchQuotes?.resume()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskFetchQuotes?.suspend()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        initStateViews()

        if let index = index {
            title = MajorIndexListCompanies.indexListDict[index.symbol]
        }

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        fetchCompanies()

        taskFetchQuotes = Plan.after(0.second, repeating: 3.second).do {
            self.fetchQuotes()
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

// MARK: - methods

extension MajorIndexListCompanies {
    private func fetchCompanies() {
        guard let index = index else { return }

        startLoading()

        var endpoint = ""
        if index.symbol == "^GSPC" {
            endpoint = "sp500_constituent"
        } else if index.symbol == "^DJI" {
            endpoint = "dowjones_constituent"
        } else {
            endpoint = "nasdaq_constituent"
        }

        let urlString = "https://financialmodelingprep.com/api/v3/\(endpoint)"
        let parameters = ["apikey": Constants.APIKey]

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(7 * 24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                var temp = [Company]()
                for value in json.arrayValue {
                    if let symbol = value["symbol"].string {
                        if let company = CompanyStore.shared.item(symbol: symbol) {
                            temp.append(company)
                        }
                    }
                }
                self.companies = temp

                self.tableView.reloadData()
                self.tableView.mj_header?.endRefreshing()
                if self.companies.count == 0 {
                    self.showNoData()
                } else {
                    self.endLoading()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.companies.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }

    private func fetchQuotes() {
        print(#function)

        guard companies.count > 0 else { return }

        var fetchCompanies = [Company]()

        if companies.count < 800 {
            fetchCompanies = companies
        } else {
            for cellTemp in tableView.visibleCells {
                if let cell = cellTemp as? CompanyCell, let company = cell.company {
                    fetchCompanies.append(company)
                }
            }
        }

        guard fetchCompanies.count > 0 else { return }

        let companySymbols = fetchCompanies.map { $0.symbol }
        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }
        let urlString = "https://financialmodelingprep.com/api/v3/quote/\(quaryPara)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameters = ["apikey": Constants.APIKey]

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .seconds(-1),
            fetchType: .online) { [weak self] response in
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

extension MajorIndexListCompanies: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchCompanies.count
        } else {
            return companies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell

        if isSearching {
            cell.company = searchCompanies[indexPath.row]
        } else {
            cell.company = companies[indexPath.row]
        }
        cell.searchText = searchText

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = searchCompanies[indexPath.row]
            navigationController?.pushViewController(companyDashboardViewController, animated: true)

        } else {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = companies[indexPath.row]
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension MajorIndexListCompanies: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        let lastSearch = searchText
        getFilteredCompanies(allCompanies: companies, searchText: searchText, completion: { resultCompanies in
            if lastSearch != searchText { return }
            self.searchCompanies = resultCompanies
            self.tableView.reloadData()
        })
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchText
        if searchBar.text == "" {
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        searchBar.text = ""
        tableView.reloadData()
    }
}
