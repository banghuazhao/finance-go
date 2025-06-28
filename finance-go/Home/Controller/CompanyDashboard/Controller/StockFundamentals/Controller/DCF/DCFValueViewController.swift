//
//  DCFValueViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/26.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import JTAppleCalendar
import JXSegmentedView
import Localize_Swift
import MJRefresh
import SnapKit
import SwiftyJSON
import Then
import UIKit

class DCFValueViewController: FGUIViewController {
    enum RequestType {
        case realTime
        case daily
        case quarterly
        case annually
    }

    var requestType: RequestType = .quarterly

    var company: Company?
    var dcfs = [DCF]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(DCFCell.self, forCellReuseIdentifier: "DCFCell")
        tv.register(DCFTitleCell.self, forCellReuseIdentifier: "DCFTitleCell")
        tv.separatorColor = UIColor.white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()
        
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
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

extension DCFValueViewController {
}

// MARK: - methods

extension DCFValueViewController {
    @objc private func fetchDataOnline() {
        guard let company = company else { return }
        startFetchData()
        var urlString = ""
        var parameters = [String: String]()
        var cacheDate = Date()

        if requestType == .realTime {
            urlString = APIManager.baseURL + "/api/v3/discounted-cash-flow/\(company.symbol)"
            cacheDate = Date().addingTimeInterval(60)
        } else if requestType == .daily {
            urlString = APIManager.baseURL + "/api/v3/historical-daily-discounted-cash-flow/\(company.symbol)"
            parameters["limit"] = "30"
            cacheDate = Date().addingTimeInterval(12 * 60 * 60)
        } else if requestType == .quarterly {
            urlString = APIManager.baseURL + "/api/v3/historical-discounted-cash-flow-statement/\(company.symbol)"
            parameters["period"] = "quarter"
            cacheDate = Date().addingTimeInterval(7 * 24 * 60 * 60)
        } else {
            urlString = APIManager.baseURL + "/api/v3/historical-discounted-cash-flow-statement/\(company.symbol)"
            cacheDate = Date().addingTimeInterval(7 * 24 * 60 * 60)
        }

        parameters["apikey"] = Constants.APIKey

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(cacheDate),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)

                    var tempDCF = [DCF]()
                    for value in json.arrayValue {
                        if self.requestType == .realTime {
                            tempDCF.append(DCF(dictRealyTime: value))
                        } else {
                            tempDCF.append(DCF(dictStatement: value))
                        }
                    }

                    self.dcfs = tempDCF
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.dcfs.count == 0 {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.dcfs.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DCFValueViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + dcfs.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DCFTitleCell", for: indexPath) as! DCFTitleCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DCFCell", for: indexPath) as! DCFCell
            cell.company = company
            cell.dcf = dcfs[indexPath.row - 1]
            return cell
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension DCFValueViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
