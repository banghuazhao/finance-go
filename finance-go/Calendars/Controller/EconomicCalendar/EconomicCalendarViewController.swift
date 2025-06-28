//
//  EconomicCalendarViewController.swift
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

class EconomicCalendarViewController: FGUIViewController {
    var monthViewDataSource = [EconomicCalendar]()
    var economicCalendars = [EconomicCalendar]()

    var selectedDate: Date?

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(MonthCalendarCell.self, forCellReuseIdentifier: "MonthCalendarCell")
        tv.register(SingleEconomicCalendarTitleCell.self, forCellReuseIdentifier: "SingleEconomicCalendarTitleCell")
        tv.register(SingleEconomicCalendarCell.self, forCellReuseIdentifier: "SingleEconomicCalendarCell")
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

        NotificationCenter.default.addObserver(self, selector: #selector(didSelectEconomicCalendarDate), name: .didSelectEconomicCalendarDate, object: nil)

        tableView.mj_header?.beginRefreshing()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MonthCalendarCell else { return }
        let visibleDates = cell.monthView.visibleDates()
        cell.monthView.viewWillTransition(to: .zero, with: coordinator, anchorDate: visibleDates.monthDates.first?.date)
    }
}

extension EconomicCalendarViewController {
    @objc func didSelectEconomicCalendarDate(notification: Notification) {
        guard let date = notification.object as? Date else { return }
        selectedDate = date
        economicCalendars = EconomicCalendarStore.shared.items(atDate: selectedDate)
        tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}

// MARK: - methods

extension EconomicCalendarViewController {
    @objc private func fetchDataOnline() {
        let urlString = APIManager.baseURL + "/api/v3/economic_calendar"
        let startDate = Date().addingTimeInterval(-60 * 60 * 24 * 30)
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

                    var calendards = [EconomicCalendar]()
                    for value in json.arrayValue {
                        let calendard = EconomicCalendar(json: value)
                        calendards.append(calendard)
                    }
                    EconomicCalendarStore.shared.resetItems(calendars: calendards)
                    self.monthViewDataSource = EconomicCalendarStore.shared.items
                    self.economicCalendars = EconomicCalendarStore.shared.items(atDate: self.selectedDate)
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

extension EconomicCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return economicCalendars.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEconomicCalendarTitleCell", for: indexPath) as! SingleEconomicCalendarTitleCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEconomicCalendarCell", for: indexPath) as! SingleEconomicCalendarCell
            cell.economicCalendar = economicCalendars[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            let calendarShowViewController = EconomicCalendarShowViewController()
            calendarShowViewController.hidesBottomBarWhenPushed = true
            calendarShowViewController.calendar = economicCalendars[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(calendarShowViewController, animated: true)
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension EconomicCalendarViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
