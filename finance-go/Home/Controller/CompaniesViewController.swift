//
//  CompaniesViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/22/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Alamofire
import Cache
import Hue
import JXSegmentedView
import Localize_Swift
import MJRefresh
import Schedule
import Sheeeeeeeeet
import SnapKit
import SwiftyJSON
import Then
import UIKit

class CompaniesViewController: FGUIViewController {
    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false
    }

    override var isStaticBackground: Bool {
        return true
    }

    var valueType: ValueType = .stock

    var taskFetchQuotes: Task?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskFetchQuotes?.resume()
        tableView.reloadData()
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

        tableView.reloadData()

        taskFetchQuotes = Plan.after(0.second, repeating: 2.second).do {
            self.fetchQuotes()
        }
    }
}

// MARK: - methods

extension CompaniesViewController {
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

extension CompaniesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CompanyStore.shared.getAll(searchType: valueType).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        cell.company = CompanyStore.shared.getAll(searchType: valueType)[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDashboardViewController = CompanyDashboardViewController()
        companyDashboardViewController.hidesBottomBarWhenPushed = true
        companyDashboardViewController.company = CompanyStore.shared.getAll(searchType: valueType)[indexPath.row]
        navigationController?.pushViewController(companyDashboardViewController, animated: true)
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension CompaniesViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
