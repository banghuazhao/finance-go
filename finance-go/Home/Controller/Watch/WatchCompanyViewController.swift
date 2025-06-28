//
//  WatchCompanyViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/28/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Alamofire
import Cache
import Hue
import Localize_Swift
import MJRefresh
import Schedule
import SnapKit
import SwiftyJSON
import Then
import UIKit

class WatchCompanyViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var watchCompanies: [Company] = [Company]()
    var searchWatchCompanies: [Company] = [Company]()
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
    var isEditingCompany: Bool = false

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
                    searchField.backgroundColor = .clear
                    searchField.attributedPlaceholder = NSAttributedString(string: "Search a Stock/Comapny/Index/Crypto/Fund/ETF/Forex".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
                    searchField.leftView?.tintColor = UIColor.white2
                }
            }
            return searchController
        }
    }()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyCell.self, forCellReuseIdentifier: "CompanyCell")
        tv.separatorStyle = .none
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 8))
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.alwaysBounceVertical = true
        tv.delaysContentTouches = false
        tv.keyboardDismissMode = .onDrag
        tv.dragDelegate = self
        tv.dragInteractionEnabled = true
    }

    lazy var noCompanyLabel = UILabel().then { label in

        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 24, height: 24)

        imageAttachment.image = UIImage(named: "icon_star")?.withRenderingMode(.alwaysTemplate).tinted(with: UIColor.lightGray)

        let string1 = NSMutableAttributedString(string: "The watchlist is empty".localized() + "\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])
        let string2 = NSMutableAttributedString(string: "Tap".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])
        let space1 = NSMutableAttributedString(string: "  ")
        let space2 = NSMutableAttributedString(string: "  ")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let string3 = NSMutableAttributedString(string: "to add".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2, NSAttributedString.Key.paragraphStyle: createParagraphStyle()])

        let mutableAttributedString = NSMutableAttributedString()

        mutableAttributedString.append(string1)
        mutableAttributedString.append(string2)
        mutableAttributedString.append(space1)
        mutableAttributedString.append(attachmentString)
        mutableAttributedString.append(space2)
        mutableAttributedString.append(string3)

        label.attributedText = mutableAttributedString
        label.numberOfLines = 2
        label.textAlignment = .center
    }

    var taskFetchQuotes: Task?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskFetchQuotes?.resume()
        watchCompanies = WatchCompanyHelper.getAllWatchCompanies()
        tableView.reloadData()
        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        taskFetchQuotes?.suspend()
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        watchCompanies = WatchCompanyHelper.getAllWatchCompanies()

        title = "Watchlist".localized()
        navigationItem.searchController = searchController

        navigationItem.rightBarButtonItem = editButtonItem

        view.addSubview(tableView)
        view.addSubview(noCompanyLabel)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noCompanyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }

        tableView.reloadData()

        taskFetchQuotes = Plan.after(0.second, repeating: 2.second).do {
            self.fetchQuotes()
        }

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

        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveWatchCompany(_:)), name: .didRemoveWatchCompany, object: nil)
    }
}

// MARK: - actions

extension WatchCompanyViewController {
    override func setEditing(_ editing: Bool, animated: Bool) {
        tableView.setEditing(false, animated: false)
        view.makeToast("Drag and drop to move company".localized())
    }
}

// MARK: - methods

extension WatchCompanyViewController {
    private func fetchQuotes() {
        print(#function)

        guard watchCompanies.count > 0 else { return }

        var fetchCompanies = [Company]()

        if watchCompanies.count < 800 {
            fetchCompanies = watchCompanies
        } else {
            for cellTemp in tableView.visibleCells {
                if let cell = cellTemp as? CompanyCell, let company = cell.company {
                    fetchCompanies.append(company)
                }
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
                let json = JSON(data)
                for value in json.arrayValue {
                    if let symbol = value["symbol"].string {
                        CompanyStore.shared.item(symbol: symbol)?.companyQuote = CompanyQuote(json: value)
                    }
                }
                if !self.isEditingCompany {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WatchCompanyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchWatchCompanies.count
        } else {
            return watchCompanies.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath) as! CompanyCell
        if isSearching {
            cell.company = searchWatchCompanies[indexPath.row]
        } else {
            cell.company = watchCompanies[indexPath.row]
        }
        cell.searchText = searchText
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = searchWatchCompanies[indexPath.row]
            navigationController?.pushViewController(companyDashboardViewController, animated: true)

        } else {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = watchCompanies[indexPath.row]
            navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        } else {
            return true
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if !isSearching {
            ImpactManager.shared.generate()
            let mover = watchCompanies.remove(at: sourceIndexPath.row)
            WatchCompanyHelper.removeWatchCompanySymbol(company: mover)
            watchCompanies.insert(mover, at: destinationIndexPath.row)
            WatchCompanyHelper.insertWatchCompanySymbol(company: mover, index: destinationIndexPath.row)
            isEditingCompany = false
        }
    }
}

// MARK: - UITableViewDragDelegate

extension WatchCompanyViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        ImpactManager.shared.generate()
        isEditingCompany = true
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = watchCompanies[indexPath.row]
        return [dragItem]
    }

    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        return param
    }
}

// MARK: - UISearchBarDelegate

extension WatchCompanyViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        let lastSearch = searchText
        getFilteredCompanies(allCompanies: watchCompanies, searchText: searchText, completion: { resultCompanies in
            if lastSearch != searchText { return }
            self.searchWatchCompanies = resultCompanies
            self.tableView.reloadData()
        })
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchText
        if searchBar.text == "" {
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        searchBar.text = ""
        tableView.dragInteractionEnabled = true
        tableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.dragInteractionEnabled = false
    }
}

extension WatchCompanyViewController {
    @objc func didRemoveWatchCompany(_ notification: Notification) {
        guard let watchCompany = notification.object as? Company else { return }
        if let index1 = watchCompanies.firstIndex(where: { company in
            company.symbol == watchCompany.symbol
        }) {
            watchCompanies.remove(at: index1)
            if !isSearching {
                tableView.deleteRows(at: [IndexPath(row: index1, section: 0)], with: .fade)
            }
        }

        if let index2 = searchWatchCompanies.firstIndex(where: { company in
            company.symbol == watchCompany.symbol
        }) {
            searchWatchCompanies.remove(at: index2)
            if isSearching {
                tableView.deleteRows(at: [IndexPath(row: index2, section: 0)], with: .fade)
            }
        }

        if watchCompanies.count == 0 {
            noCompanyLabel.isHidden = false
        } else {
            noCompanyLabel.isHidden = true
        }
    }
}
