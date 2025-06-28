//
//  FinancialTermsAndDefinitionViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Sheeeeeeeeet
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class FinancialTermsAndDefinitionViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var searchText: String = ""
    var searchedFinancialTerms: [FinancialTerm] = []
    var filterIndex: Int = 0 {
        didSet {
            if filterIndex == 0 {
                navigationItem.rightBarButtonItem?.tintColor = .white
            } else {
                navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            }
        }
    }

    var isSearching: Bool {
        return searchText != ""
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
                sc.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search financial terms".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
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
                    searchField.attributedPlaceholder = NSAttributedString(string: "Search financial terms".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white2])
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
        tv.register(FinancialTermsCell.self, forCellReuseIdentifier: "FinancialTermsCell")
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.separatorColor = UIColor.lightGray
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_searchPaper")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(filterFinancialDefinition(_:)))

        title = "Financial Terms and Definition".localized()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview()
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
    }
}

// MARK: - actions

extension FinancialTermsAndDefinitionViewController {
    @objc func filterFinancialDefinition(_ sender: UIBarButtonItem) {
        var items: [MenuItem] = []
        for (i, itemTitle) in FinancialTermCategory.allCases.enumerated() {
            let item = SingleSelectItem(title: itemTitle.rawValue.localized(), isSelected: i == filterIndex, image: nil)
            items.append(item)
        }

        let cancelButton = CancelButton(title: "Cancel".localized())
        items.append(cancelButton)
        let menu = Menu(title: "Select Category".localized(), items: items)

        let sheet = menu.toActionSheet { [weak self] _, item in
            guard let self = self else { return }
            guard item.title != "Cancel".localized() && item.title != "Select Category".localized() else { return }

            let title = item.title
            self.filterIndex = items.firstIndex { (menuItem) -> Bool in
                menuItem.title == title
            } ?? 0

            if self.isSearching && self.searchText != "" {
                self.searchedFinancialTerms = FinancialTermStore.shared.getAll(filterIndex: self.filterIndex).filter({ (financialTerm) -> Bool in

                    let titleText = financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") ? financialTerm.name : "\(financialTerm.name) (\(financialTerm.name.localized(using: "FinancialTermsLocalized")))"

                    if titleText.contains(self.searchText) {
                        return true
                    }
                    return false
                })
            }
            self.tableView.reloadData()
        }

        sheet.present(in: self, from: sender)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FinancialTermsAndDefinitionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedFinancialTerms.count
        } else {
            return FinancialTermStore.shared.getAll(filterIndex: filterIndex).count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinancialTermsCell", for: indexPath) as! FinancialTermsCell
            cell.financialTerm = searchedFinancialTerms[indexPath.row]
            cell.searchText = searchText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinancialTermsCell", for: indexPath) as! FinancialTermsCell
            cell.financialTerm = FinancialTermStore.shared.getAll(filterIndex: filterIndex)[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let financialDefinitionViewController = FinancialDefinitionViewController()
        if isSearching {
            financialDefinitionViewController.financialTerm = searchedFinancialTerms[indexPath.row]
        } else {
            financialDefinitionViewController.financialTerm = FinancialTermStore.shared.getAll(filterIndex: filterIndex)[indexPath.row]
        }
        navigationController?.pushViewController(financialDefinitionViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension FinancialTermsAndDefinitionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText != "" {
            searchedFinancialTerms = FinancialTermStore.shared.getAll(filterIndex: filterIndex).filter({ (financialTerm) -> Bool in

                let titleText = financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") ? financialTerm.name : "\(financialTerm.name) (\(financialTerm.name.localized(using: "FinancialTermsLocalized")))"

                if titleText.contains(searchText) {
                    return true
                }
                return false
            })
        }
        tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchText
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        tableView.reloadData()
    }
}
