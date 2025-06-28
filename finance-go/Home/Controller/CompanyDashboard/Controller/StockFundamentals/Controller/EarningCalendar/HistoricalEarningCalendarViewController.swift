//
//  HistoricalEarningCalendarViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/31.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import JXSegmentedView
import MJRefresh
import SwiftyJSON
import UIKit

class HistoricalEarningCalendarViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    enum RequestType {
        case earning
        case stockSplit
        case dividend
    }

    var requestType: RequestType = .earning

    var company: Company?

    var earningCalendars = [EarningCalendar]()
    var dividendCalendars = [DividendCalendar]()
    var stockSplitCalendars = [StockSplitCalendar]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self

        tv.register(HistoricalEarningCalendarTitleCell.self, forCellReuseIdentifier: "HistoricalEarningCalendarTitleCell")
        tv.register(HistoricalDividendCalendarTitleCell.self, forCellReuseIdentifier: "HistoricalDividendCalendarTitleCell")
        tv.register(HistoricalStockSplitCalendarTitleCell.self, forCellReuseIdentifier: "HistoricalStockSplitCalendarTitleCell")

        tv.register(HistoricalEarningCalendarCell.self, forCellReuseIdentifier: "HistoricalEarningCalendarCell")
        tv.register(HistoricalDividendCalendarCell.self, forCellReuseIdentifier: "HistoricalDividendCalendarCell")
        tv.register(HistoricalStockSplitCalendarCell.self, forCellReuseIdentifier: "HistoricalStockSplitCalendarCell")

        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.separatorColor = .white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 16))
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()

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

extension HistoricalEarningCalendarViewController {
    @objc func fetchDataOnline() {
        guard let company = company else { return }
        startFetchData()
        var urlString = APIManager.baseURL + "/api/v3/historical/earning_calendar/\(company.symbol)"

        if requestType == .dividend {
            urlString = APIManager.baseURL + "/api/v3/historical-price-full/stock_dividend/\(company.symbol)"
        } else if requestType == .stockSplit {
            urlString = APIManager.baseURL + "/api/v3/historical-price-full/stock_split/\(company.symbol)"
        }

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(2 * 24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    if self.requestType == .earning {
                        let json = JSON(data)
                        var calendards = [EarningCalendar]()
                        for value in json.arrayValue {
                            let calendard = EarningCalendar(json: value)
                            calendards.append(calendard)
                        }
                        self.earningCalendars = calendards
                    } else if self.requestType == .dividend {
                        let json = JSON(data)["historical"]
                        var calendards = [DividendCalendar]()
                        for value in json.arrayValue {
                            var calendard = DividendCalendar(json: value)
                            calendard.symbol = self.company?.symbol ?? "No Data".localized()
                            calendards.append(calendard)
                        }
                        self.dividendCalendars = calendards
                    } else if self.requestType == .stockSplit {
                        let json = JSON(data)["historical"]
                        var calendards = [StockSplitCalendar]()
                        for value in json.arrayValue {
                            let calendard = StockSplitCalendar(json: value)
                            calendard.symbol = self.company?.symbol ?? "No Data".localized()
                            calendards.append(calendard)
                        }
                        self.stockSplitCalendars = calendards
                    }
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.requestType == .earning {
                        if self.earningCalendars.count == 0 {
                            self.showNoData()
                        }
                    } else if self.requestType == .dividend {
                        if self.dividendCalendars.count == 0 {
                            self.showNoData()
                        }
                    } else if self.requestType == .stockSplit {
                        if self.stockSplitCalendars.count == 0 {
                            self.showNoData()
                        }
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.requestType == .earning {
                    if self.earningCalendars.count == 0 {
                        self.showNetworkError()
                    }
                } else if self.requestType == .dividend {
                    if self.dividendCalendars.count == 0 {
                        self.showNetworkError()
                    }
                } else if self.requestType == .stockSplit {
                    if self.stockSplitCalendars.count == 0 {
                        self.showNetworkError()
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HistoricalEarningCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if requestType == .earning {
                return earningCalendars.count
            } else if requestType == .dividend {
                return dividendCalendars.count
            } else {
                return stockSplitCalendars.count
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if requestType == .earning {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalEarningCalendarTitleCell", for: indexPath) as! HistoricalEarningCalendarTitleCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalEarningCalendarCell", for: indexPath) as! HistoricalEarningCalendarCell
                cell.earningCalendar = earningCalendars[indexPath.row]
                return cell
            }
        } else if requestType == .dividend {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalDividendCalendarTitleCell", for: indexPath) as! HistoricalDividendCalendarTitleCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalDividendCalendarCell", for: indexPath) as! HistoricalDividendCalendarCell
                cell.dividendCalendar = dividendCalendars[indexPath.row]
                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalStockSplitCalendarTitleCell", for: indexPath) as! HistoricalStockSplitCalendarTitleCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricalStockSplitCalendarCell", for: indexPath) as! HistoricalStockSplitCalendarCell
                cell.stockSplitCalendar = stockSplitCalendars[indexPath.row]
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 1 {
            let calendarShowViewController = CalendarShowViewController()
            if requestType == .earning {
                calendarShowViewController.calendar = earningCalendars[indexPath.row]
            } else if requestType == .dividend {
                calendarShowViewController.calendar = dividendCalendars[indexPath.row]
            } else {
                calendarShowViewController.calendar = stockSplitCalendars[indexPath.row]
            }
            navigationController?.pushViewController(calendarShowViewController, animated: true)
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension HistoricalEarningCalendarViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
