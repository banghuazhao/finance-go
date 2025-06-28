//
//  MostCompaniesViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/22/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
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
import SnapKit
import SwiftyJSON
import Then
import UIKit

class MostCompaniesViewController: FGUIViewController {
    private var mostCompanies: [Company] = [Company]()

    enum MostType {
        case active
        case gainer
        case loser
    }

    var mostType: MostType = .active

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false
    }

    override var isStaticBackground: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        initStateViews()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - actions

extension MostCompaniesViewController {
}

// MARK: - methods

extension MostCompaniesViewController {
    @objc private func fetchDataOnline() {
        startFetchData()
        var urlString = APIManager.baseURL
        if mostType == .active {
            urlString += "/api/v3/actives"
        } else if mostType == .gainer {
            urlString += "/api/v3/gainers"
        } else {
            urlString += "/api/v3/losers"
        }

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .seconds(10 * 60),
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var temp = [Company]()
                    for value in json.arrayValue {
                        let symbol = value["ticker"].stringValue
                        CompanyStore.shared.item(symbol: symbol)?.price =  Double(value["price"].stringValue)
                        CompanyStore.shared.item(symbol: symbol)?.changesPercentage =  Double(value["changesPercentage"].stringValue)
                        if let company = CompanyStore.shared.item(symbol: symbol) {
                            temp.append(company)
                        }
                    }
                    self.mostCompanies = temp
                } completion: {
                    self.tableView.reloadData()
                    if !response.isCache {
                        self.tableView.mj_header?.endRefreshing()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.mostCompanies.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MostCompaniesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostCompanies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        cell.company = mostCompanies[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let companyDashboardViewController = CompanyDashboardViewController()
        companyDashboardViewController.hidesBottomBarWhenPushed = true
        companyDashboardViewController.company = mostCompanies[indexPath.row]
        navigationController?.pushViewController(companyDashboardViewController, animated: true)
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension MostCompaniesViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
