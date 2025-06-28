//
//  CompanySearchResultViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/14.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import JXSegmentedView
import Localize_Swift
import MJRefresh
import Schedule
import Sheeeeeeeeet
import SnapKit
import Then
import UIKit
import SwiftyJSON

class CompanySearchResultViewController: FGUIViewController {
    var searchCompanies = [Company]()
    var filterExchange: String = "All" {
        didSet {
            let lastSearch = searchText
            getFilteredCompanies(allCompanies: CompanyStore.shared.getAll(exchange: filterExchange), searchText: searchText, completion: { resultCompanies in
                if lastSearch != self.searchText { return }
                self.searchCompanies = resultCompanies
                self.tableView.reloadData()
            })
        }
    }

    var searchText: String = "" {
        didSet {
            let lastSearch = searchText
            getFilteredCompanies(allCompanies: CompanyStore.shared.getAll(exchange: filterExchange), searchText: searchText, completion: { resultCompanies in
                if lastSearch != self.searchText { return }
                self.searchCompanies = resultCompanies
                self.tableView.reloadData()
            })
        }
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false
    }

    override var isStaticBackground: Bool {
        return true
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

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }

        taskFetchQuotes = Plan.after(0.second, repeating: 2.second).do {
            self.fetchQuotes()
        }
    }
}

// MARK: - methods

extension CompanySearchResultViewController {
    private func fetchQuotes() {
        print(#function)
        var fetchCompanies = [Company]()

        for cellTemp in tableView.visibleCells {
            if let cell = cellTemp as? CompanyCell, let company = cell.company {
                fetchCompanies.append(company)
            }
        }

        guard fetchCompanies.count > 0 else { return }

        let companySymbols = fetchCompanies.map { $0.symbol }
        let quaryPara = companySymbols.reduce("") { text, symbol in
            text.isEmpty ? symbol : text + "," + symbol
        }
        let urlString = "https://financialmodelingprep.com/api/v3/quote/\(quaryPara)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameters = ["apikey": Constants.APIKey]
        AF.request(urlString, parameters: parameters).responseData { response in
            switch response.result {
            case let .success(data):
                print(urlString)
                let json = JSON(data)
                for value in json.arrayValue {
                    if let symbol = value["symbol"].string {
                        CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
                    }
                }
                self.tableView.reloadData()
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CompanySearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompanies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        cell.company = searchCompanies[indexPath.row]
        cell.searchText = searchText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDashboardViewController = CompanyDashboardViewController()
        companyDashboardViewController.hidesBottomBarWhenPushed = true
        companyDashboardViewController.company = searchCompanies[indexPath.row]
        navigationController?.pushViewController(companyDashboardViewController, animated: true)
    }
}
