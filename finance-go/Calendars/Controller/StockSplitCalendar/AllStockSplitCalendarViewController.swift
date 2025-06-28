//
//  AllStockSplitCalendarViewController.swift
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

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class AllStockSplitCalendarViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var stockSplitCalendars = [StockSplitCalendar]()
    var stockSplitCalendarGroups = [[StockSplitCalendar]]()
    var dates = [Date]()
    var searchStockSplitCalendars = [StockSplitCalendar]()
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

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(SingleStockSplitCalendarTitleCell.self, forCellReuseIdentifier: "SingleStockSplitCalendarTitleCell")
        tv.register(SingleStockSplitCalendarCell.self, forCellReuseIdentifier: "SingleStockSplitCalendarCell")
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
                    searchField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Comapny/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
                    searchField.leftView?.tintColor = UIColor.white2
                }
            }
            return searchController
        }
    }()

    var activityIndicator = UIActivityIndicatorView().then { indicator in
        if #available(iOS 13.0, *) {
            indicator.style = .large
            indicator.color = .white
        } else {
            indicator.style = .white
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stock Split Calendar".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        navigationItem.searchController = searchController

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()

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

        fetchDataOnline()
    }
}

// MARK: - actions

extension AllStockSplitCalendarViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        var str: String = ""
        var fileName: String = ""

        str += "\("Symbol".localized())\t\("Company".localized())\t\("Ratio".localized())\t\("Date".localized())\n"

        for stockSplitCalendar in stockSplitCalendars {
            let symbol = stockSplitCalendar.symbol
            let name = CompanyStore.shared.companyName(symbol: symbol)
            let ratio = stockSplitCalendar.stockSplitRatio
            let date = stockSplitCalendar.date
            str += "\(symbol)\t\(name)\t\(ratio)\t\(date)\n"
        }

        fileName = "\("Stock Split Calendar".localized()).txt"

        let file = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create share file: \(err)")
        }

        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = (sender.value(forKey: "view") as? UIView)?.bounds ?? .zero
            popoverController.sourceView = sender.value(forKey: "view") as? UIView
        }

        activityVC.completionWithItemsHandler = { (_, completed: Bool, _: [Any]?, error: Error?) in
            if completed {
                if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                    print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
                } else {
                    #if !targetEnvironment(macCatalyst)
                        GADInterstitialAd.load(withAdUnitID: Constants.GoogleAdsID.interstitialAdID, request: GADRequest()) { ad, error in
                            if let error = error {
                                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                return
                            }
                            if let ad = ad {
                                ad.present(fromRootViewController: UIApplication.getTopMostViewController() ?? self)
                                InterstitialAdsRequestHelper.resetRequestCount()
                            } else {
                                print("interstitial Ad wasn't ready")
                            }
                        }
                    #endif
                }
            } else {
                print("UIAlertController not completed")
            }
        }

        present(activityVC, animated: true, completion: {
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                #if targetEnvironment(macCatalyst)
                    let moreAppsViewController = MoreAppsViewController()
                    moreAppsViewController.isAds = true
                    (UIApplication.getTopMostViewController() ?? self).present(FGUINavigationController(rootViewController: moreAppsViewController), animated: true, completion: nil)
                #endif
            }
        })
    }
}

// MARK: - methods

extension AllStockSplitCalendarViewController {
    private func fetchDataOnline() {
        let urlString = APIManager.baseURL + "/api/v3/stock_split_calendar"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(4 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
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
                    self.stockSplitCalendars = StockSplitCalendarStore.shared.items

                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"

                    var tempDates = [Date]()
                    tempDates = self.stockSplitCalendars.map { stockSplitCalendar in
                        if let date = formatter.date(from: stockSplitCalendar.date) {
                            return date
                        }
                        return Date()
                    }

                    tempDates = Array(Set(tempDates))
                    if tempDates.count > 0 {
                        tempDates.sort { date1, date2 in
                            date1 > date2
                        }
                    }

                    var tempStockSplitCalendarGroups = [[StockSplitCalendar]]()
                    for date in tempDates {
                        tempStockSplitCalendarGroups.append(StockSplitCalendarStore.shared.items(atDate: date))
                    }
                    self.dates = tempDates
                    self.stockSplitCalendarGroups = tempStockSplitCalendarGroups
                } completion: {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AllStockSplitCalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1 + 1
        } else {
            return 1 + dates.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if isSearching {
                return searchStockSplitCalendars.count
            } else {
                return stockSplitCalendarGroups[section - 1].count
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNormalMagnitude
        } else {
            if isSearching {
                return .leastNormalMagnitude
            } else {
                return 40
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            if isSearching {
                return UIView()
            } else {
                let view = UIView()
                view.backgroundColor = .navBarColor
                let label = UILabel()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: dates[section - 1])
                label.text = "Date".localized() + ": " + dateString
                label.backgroundColor = UIColor.clear
                label.textColor = .white1
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(20)
                    make.centerY.equalToSuperview()
                }
                return view
            }
        } else {
            return UIView()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStockSplitCalendarTitleCell", for: indexPath) as! SingleStockSplitCalendarTitleCell
            return cell
        } else {
            if isSearching {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStockSplitCalendarCell", for: indexPath) as! SingleStockSplitCalendarCell
                cell.stockSplitCalendar = searchStockSplitCalendars[indexPath.row]
                cell.searchText = searchText
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStockSplitCalendarCell", for: indexPath) as! SingleStockSplitCalendarCell
                cell.stockSplitCalendar = stockSplitCalendarGroups[indexPath.section - 1][indexPath.row]
                cell.searchText = searchText
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let calendarShowViewController = CalendarShowViewController()
            calendarShowViewController.hidesBottomBarWhenPushed = true
            if isSearching {
                calendarShowViewController.calendar = searchStockSplitCalendars[indexPath.row]
            } else {
                calendarShowViewController.calendar = stockSplitCalendarGroups[indexPath.section - 1][indexPath.row]
            }
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(calendarShowViewController, animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate

extension AllStockSplitCalendarViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText != "" {
            let searchTextLower = searchText.lowercased()
            var temp = StockSplitCalendarStore.shared.items.filter({ (stockSplitCalendar) -> Bool in
                let symbol = stockSplitCalendar.symbol
                if symbol.lowercased().contains(searchTextLower) {
                    return true
                }
                if let company = CompanyStore.shared.item(symbol: symbol), company.name.lowercased().contains(searchTextLower) {
                    return true
                }

                return false
            })

            temp.sort { c1, c2 in
                let s1 = c1.symbol.lowercased()
                let s2 = c2.symbol.lowercased()
                let index1: Int = s1.indexOfSubstring(subString: searchTextLower) ?? 10000
                let index2: Int = s2.indexOfSubstring(subString: searchTextLower) ?? 10000
                return index1 < index2
            }

            searchStockSplitCalendars = temp
        }
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchText
        if searchBar.text == "" {
            isSearching = false
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchText = ""
        searchBar.text = ""
        tableView.reloadData()
    }
}
