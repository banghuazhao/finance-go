//
//  StockSplitCalendarViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/5.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import Hue
import JTAppleCalendar
import JXSegmentedView
import Localize_Swift
import MJRefresh
import SnapKit
import Then
import UIKit
import SwiftyJSON
import Alamofire

class StockSplitCalendarViewController: FGUIViewController {
    var monthViewDataSource = [StockSplitCalendar]()
    var stockSplitCalendars = [StockSplitCalendar]()

    var selectedDate: Date?

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(MonthCalendarCell.self, forCellReuseIdentifier: "MonthCalendarCell")
        tv.register(SingleStockSplitCalendarTitleCell.self, forCellReuseIdentifier: "SingleStockSplitCalendarTitleCell")
        tv.register(SingleStockSplitCalendarCell.self, forCellReuseIdentifier: "SingleStockSplitCalendarCell")
        tv.separatorColor = UIColor.white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        if #available(iOS 15.0, *) {
            tv.tableHeaderView = UIView()
        }
    }

    override var isStaticBackground: Bool {
        return true
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        selectedDate = Date()

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        NotificationCenter.default.addObserver(self, selector: #selector(didSelectStockSplitCalendarDate), name: .didSelectStockSplitCalendarDate, object: nil)

        tableView.mj_header?.beginRefreshing()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MonthCalendarCell else { return }
        let visibleDates = cell.monthView.visibleDates()
        cell.monthView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
}

extension StockSplitCalendarViewController {
    @objc func didSelectStockSplitCalendarDate(notification: Notification) {
        guard let date = notification.object as? Date else { return }
        selectedDate = date
        stockSplitCalendars = StockSplitCalendarStore.shared.items(atDate: selectedDate)
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}

// MARK: - methods

extension StockSplitCalendarViewController {
    
    @objc private func fetchDataOnline() {
        let urlString = APIManager.baseURL + "/api/v3/stock_split_calendar"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(4 * 60 * 60)),
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)

                    var calendards = [StockSplitCalendar]()
                    for value in json.arrayValue {
                        let calendard = StockSplitCalendar(json: value)
                        calendards.append(calendard)
                    }
                    StockSplitCalendarStore.shared.resetItems(stockSplitCalendars: calendards)
                    self.monthViewDataSource = StockSplitCalendarStore.shared.items
                    self.stockSplitCalendars = StockSplitCalendarStore.shared.items(atDate: self.selectedDate)
                } completion: {
                    self.tableView.reloadData()
                    if !response.isCache {
                        self.tableView.mj_header?.endRefreshing()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StockSplitCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return stockSplitCalendars.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 360
        } else {
            return 56
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCalendarCell", for: indexPath) as! MonthCalendarCell
            cell.calendars = monthViewDataSource
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStockSplitCalendarTitleCell", for: indexPath) as! SingleStockSplitCalendarTitleCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStockSplitCalendarCell", for: indexPath) as! SingleStockSplitCalendarCell
            cell.stockSplitCalendar = stockSplitCalendars[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let calendarShowViewController = CalendarShowViewController()
            calendarShowViewController.hidesBottomBarWhenPushed = true
            calendarShowViewController.calendar = stockSplitCalendars[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(calendarShowViewController, animated: true)
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension StockSplitCalendarViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
