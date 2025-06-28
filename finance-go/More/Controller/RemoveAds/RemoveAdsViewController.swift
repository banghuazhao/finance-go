//
//  RemoveAdsViewController.swift
//  Top Rankings
//
//  Created by Banghua Zhao on 2021/2/10.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import MBProgressHUD
import StoreKit
import Toast_Swift
import UIKit
#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class RemoveAdsViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var products: [SKProduct] = []

    lazy var noDatalabel: UILabel = {
        let label = UILabel()
        label.text = "No Data".localized()
        label.textColor = .white1
        label.textAlignment = .center
        return label
    }()

    lazy var requestlabel: UILabel = {
        let label = UILabel()
        label.text = "\("Requesting the product".localized())..."
        label.textColor = .white1
        label.textAlignment = .center
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(RemoveAdsCell.self, forCellReuseIdentifier: "RemoveAdsCell")
        tableView.register(RemoveAdsAboutCell.self, forCellReuseIdentifier: "RemoveAdsAboutCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorColor = UIColor.white3
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 80))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Remove Ads".localized()
        view.addSubview(tableView)
        view.addSubview(noDatalabel)
        view.addSubview(requestlabel)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noDatalabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        requestlabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noDatalabel.isHidden = true
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

        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "\("Requesting the product".localized())..."
        RemoveAdsProduct.store.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)

                self.requestlabel.isHidden = true
                if success {
                    self.products = products!
                    self.products.forEach { product in
                        print("product.localizedTitle: \(product.localizedTitle)")
                        print("product.localizedDescription: \(product.localizedDescription)")
                    }
                    self.tableView.reloadData()
                } else {
                    self.noDatalabel.isHidden = false
                    self.view.makeToast("Request failed".localized(), duration: 2.0)
                }
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseDoneNotification(_:)), name: .IAPHelperPurchaseDoneNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseFailNotification(_:)), name: .IAPHelperPurchaseFailNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestoreNotification(_:)), name: .IAPHelperRestoreNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestoreFailNotification(_:)), name: .IAPHelperRestoreFailNotification, object: nil)

        #if !targetEnvironment(macCatalyst)
            NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
        #endif
    }
}

// MARK: - actions

extension RemoveAdsViewController {
    @objc func handlePurchaseNotification(_ notification: Notification) {
        tableView.reloadData()
        #if !targetEnvironment(macCatalyst)
            bannerView.removeFromSuperview()
        #endif
    }

    @objc func handlePurchaseDoneNotification(_ notification: Notification) {
        MBProgressHUD.hide(for: view, animated: true)
        view.makeToast("The purchase is successful".localized(), duration: 2.0)
        IAPHelper.isPurchasing = false
    }

    @objc func handleRestoreNotification(_ notification: Notification) {
        MBProgressHUD.hide(for: view, animated: true)
        view.makeToast("The purchase is restored".localized(), duration: 2.0)
    }

    @objc func handlePurchaseFailNotification(_ notification: Notification) {
        MBProgressHUD.hide(for: view, animated: true)
        view.makeToast("The purchase is failed".localized(), duration: 2.0)
        IAPHelper.isPurchasing = false
    }

    @objc func handleRestoreFailNotification(_ notification: Notification) {
        MBProgressHUD.hide(for: view, animated: true)
        view.makeToast("No product to be restored".localized(), duration: 2.0)
    }
}

// MARK: - UITableViewDataSource

extension RemoveAdsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count > 0 ? products.count + 2 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < products.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveAdsCell") as! RemoveAdsCell
            cell.product = products[indexPath.row]
            return cell
        } else if indexPath.row == products.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveAdsCell") as! RemoveAdsCell
            cell.nameLabel.text = "Restore purchase".localized()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveAdsAboutCell") as! RemoveAdsAboutCell
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension RemoveAdsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < products.count {
            let productIdentifier = products[indexPath.row].productIdentifier
            if RemoveAdsProduct.store.isProductPurchased(productIdentifier) {
                print("Previously purchased: \(productIdentifier)")
                view.makeToast("Remove Ads forever has been purchased".localized(), duration: 2.0)
            } else {
                IAPHelper.isPurchasing = true
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.label.text = "\("Purchasing".localized())..."
                RemoveAdsProduct.store.buyProduct(products[indexPath.row])
            }
        } else if indexPath.row == products.count {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = "\("Restoring purchase".localized())..."
            RemoveAdsProduct.store.restorePurchases()
        }
    }
}
