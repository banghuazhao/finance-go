//
//  CompaniesSearchViewController.swift
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
import Sheeeeeeeeet
import SnapKit
import SwiftyJSON
import Then
import UIKit

class CompaniesSearchViewController: FGUIViewController {
    var searchCompanies = [Company]()
    var tags = CompanyStore.shared.getAll()[0 ... 20].map { $0.symbol }
    var filterExchnage = "All"

    lazy var searchController: UISearchController = {
        if #available(iOS 13.0, *) {
            let searchController = UISearchController().then { sc in
                sc.searchBar.delegate = self
                sc.searchBar.barStyle = .black
                sc.hidesNavigationBarDuringPresentation = false
                sc.obscuresBackgroundDuringPresentation = false
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
                sc.obscuresBackgroundDuringPresentation = false
                sc.hidesNavigationBarDuringPresentation = false
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

    lazy var tableView = UITableView(frame: .zero, style: .grouped).then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(HotSearchTagCell.self, forCellReuseIdentifier: "HotSearchTagCell")
        tv.register(SearchHistoryCell.self, forCellReuseIdentifier: "SearchHistoryCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
        tv.delaysContentTouches = false
        if #available(iOS 15.0, *) {
            #if !targetEnvironment(macCatalyst)
                tv.sectionHeaderTopPadding = 0
            #endif
        }
    }

    lazy var companySearchResultViewController = CompanySearchResultViewController()

    override var isStaticBackground: Bool {
        return true
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            searchController.isActive = false
        }
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchController.searchBar
        view.addSubview(companySearchResultViewController.view)
        companySearchResultViewController.view.snp.makeConstraints { make in
            make.size.equalTo(view)
        }
        addChild(companySearchResultViewController)

        navigationController?.navigationBar.topItem?.title = ""

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_filter_menu"), style: .plain, target: self, action: #selector(tapFilterMenu(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
        }

        fetchHotSearches()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.searchController.searchBar.becomeFirstResponder()
        })
    }
}

// MARK: - actions

extension CompaniesSearchViewController {
    @objc func tapFilterMenu(_ sender: UIBarButtonItem) {
        var items: [MenuItem] = []

        let exchangeNames = ["All", "Nasdaq", "New York Stock Exchange", "The Stock Exchange of Hong Kong", "Shanghai", "Shenzhen", "Tokyo", "Taipei Exchange", "LSE", "Paris", "Berlin", "Toronto", "Amsterdam", "Brussels", "Lisbon", "OTC", "NYSEArca", "Taiwan", "YHD", "EURONEXT", "Swiss", "AMEX", "MCX", "XETRA", "NSE", "SIX", "OSE", "Sao Paolo", "TSXV", "Frankfurt", "NCM", "MCE", "ASE", "OSL", "Oslo", "FGI", "Irish", "Canadian Sec", "NZSE", "Jakarta", "Vienna", "Santiago", "Hamburg", "Copenhagen", "Helsinki", "Athens", "Milan", "KSE", "KOSDAQ", "Stockholm", "Istanbul", "Mexico", "Johannesburg", "SAT", "São Paulo", "Tel Aviv", "Warsaw", "Thailand", "IOB", "Qatar", "Kuala Lumpur", "Prague", "SES", "Saudi", "BATS Exchange", "NYSE American", "BATS"]

        for itemTitle in exchangeNames {
            let item = SingleSelectItem(title: itemTitle, isSelected: itemTitle == filterExchnage, image: nil)
            items.append(item)
        }

        let cancelButton = CancelButton(title: "Cancel".localized())
        items.append(cancelButton)
        let menu = Menu(title: "Select a Stock Exchange".localized(), items: items)

        let sheet = menu.toActionSheet { [weak self] _, item in
            guard let self = self else { return }
            guard item.title != "Cancel".localized() && item.title != "Select a Stock Exchange".localized() else { return }

            let title = item.title
            self.filterExchnage = items.first { menuItem in
                menuItem.title == title
            }?.title ?? "All"

            self.companySearchResultViewController.filterExchange = self.filterExchnage
        }
        sheet.present(in: self, from: sender)
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - methods

extension CompaniesSearchViewController {
    func fetchHotSearches() {
        let urlString = APIManager.baseURL + "/api/v3/actives"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .seconds(10 * 60),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)
                    var temp = [Company]()
                    for value in json.arrayValue where temp.count < 20 {
                        let symbol = value["ticker"].stringValue
                        CompanyStore.shared.item(symbol: symbol)?.price = Double(value["price"].stringValue)
                        CompanyStore.shared.item(symbol: symbol)?.changesPercentage = Double(value["changesPercentage"].stringValue)
                        if let company = CompanyStore.shared.item(symbol: symbol) {
                            temp.append(company)
                        }
                    }
                    self.tags = temp.map { $0.symbol }
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    func showSearch() {
        companySearchResultViewController.view.isHidden = false
        tableView.isHidden = true
        view.bringSubviewToFront(companySearchResultViewController.view)
    }

    func hideSearch() {
        companySearchResultViewController.view.isHidden = true
        tableView.isHidden = false
    }

    @objc func trashButtonTapped() {
        SearchHistoryHelper.removeAllSearchHistory()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CompaniesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return SearchHistoryHelper.getAllSearchHistory().count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        if section == 0 {
            label.text = "Trending".localized()
        } else {
            label.text = "History".localized()
            let trashButton = UIButton()
            trashButton.setImage(UIImage(named: "icon_trash")?.withRenderingMode(.alwaysTemplate), for: .normal)
            trashButton.tintColor = .white2
            trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
            view.addSubview(trashButton)
            trashButton.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(20)
                make.centerY.equalToSuperview()
                make.size.equalTo(20)
            }
            if SearchHistoryHelper.getAllSearchHistory().count == 0 {
                trashButton.isHidden = true
            } else {
                trashButton.isHidden = false
            }
        }
        label.backgroundColor = UIColor.clear
        label.textColor = .white1
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotSearchTagCell", for: indexPath) as! HotSearchTagCell
            cell.tags = tags
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryCell", for: indexPath) as! SearchHistoryCell
            let searchHistory = SearchHistoryHelper.getAllSearchHistory()[indexPath.row]
            cell.searchItem = searchHistory
            cell.deleteAction = { [weak self] in
                guard let self = self else { return }
                SearchHistoryHelper.removeSearchHistory(history: searchHistory)
                self.tableView.reloadData()
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let searchHistory = SearchHistoryHelper.getAllSearchHistory()[indexPath.row]
            searchController.searchBar.text = searchHistory
            companySearchResultViewController.searchText = searchHistory
            if title == "" {
                hideSearch()
            } else {
                showSearch()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension CompaniesSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        companySearchResultViewController.searchText = searchText
        if searchText == "" {
            hideSearch()
        } else {
            showSearch()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        companySearchResultViewController.searchText = searchText
        if searchText == "" {
            hideSearch()
        } else {
            SearchHistoryHelper.appendSearchHistory(history: searchText)
            tableView.reloadData()
            showSearch()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        companySearchResultViewController.searchText = ""
        hideSearch()
    }
}

// MARK: - HotSearchTagCellDelegate

extension CompaniesSearchViewController: HotSearchTagCellDelegate {
    func tagPressed(title: String) {
        searchController.searchBar.text = title
        companySearchResultViewController.searchText = title
        if title == "" {
            hideSearch()
        } else {
            showSearch()
        }
    }
}
