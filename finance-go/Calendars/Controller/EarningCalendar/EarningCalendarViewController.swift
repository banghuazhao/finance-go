//
//  EarningCalendarViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/5.
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

class EarningCalendarViewController: FGUIViewController {
    var monthViewDataSource = [EarningCalendar]()
    var earningCalendars = [EarningCalendar]()

    var selectedDate: Date?

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(MonthCalendarCell.self, forCellReuseIdentifier: "MonthCalendarCell")
        tv.register(SingleEarningCalendarTitleCell.self, forCellReuseIdentifier: "SingleEarningCalendarTitleCell")
        tv.register(SingleEarningCalendarCell.self, forCellReuseIdentifier: "SingleEarningCalendarCell")
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

        NotificationCenter.default.addObserver(self, selector: #selector(didSelectEarningCalendarDate), name: .didSelectEarningCalendarDate, object: nil)

        tableView.mj_header?.beginRefreshing()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MonthCalendarCell else { return }
        let visibleDates = cell.monthView.visibleDates()
        cell.monthView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
}

extension EarningCalendarViewController {
    @objc func didSelectEarningCalendarDate(notification: Notification) {
        guard let date = notification.object as? Date else { return }
        selectedDate = date
        earningCalendars = EarningCalendarStore.shared.items(atDate: selectedDate)
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}

// MARK: - methods

extension EarningCalendarViewController {
    @objc private func fetchDataOnline() {
        let urlString = APIManager.baseURL + "/api/v3/earning_calendar"
        let startDate = Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2)
        let endDate = Date().addingTimeInterval(60 * 60 * 24 * 31)

        let parameters = [
            "from": startDate.stringDay_yyyy_MM_dd,
            "to": endDate.stringDay_yyyy_MM_dd,
            "apikey": Constants.APIKey,
        ]
        
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(4 * 60 * 60)),
            fetchType: .cacheAndOnline) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var calendards = [EarningCalendar]()
                    for value in json.arrayValue {
                        let calendard = EarningCalendar(json: value)
                        calendards.append(calendard)
                    }
                    EarningCalendarStore.shared.resetItems(earningCalendars: calendards)
                    self.monthViewDataSource = EarningCalendarStore.shared.items
                    self.earningCalendars = EarningCalendarStore.shared.items(atDate: self.selectedDate)
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

extension EarningCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return earningCalendars.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEarningCalendarTitleCell", for: indexPath) as! SingleEarningCalendarTitleCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEarningCalendarCell", for: indexPath) as! SingleEarningCalendarCell
            cell.earningCalendar = earningCalendars[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let calendarShowViewController = CalendarShowViewController()
            calendarShowViewController.hidesBottomBarWhenPushed = true
            calendarShowViewController.calendar = earningCalendars[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(calendarShowViewController, animated: true)
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension EarningCalendarViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
