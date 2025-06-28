//
//  HolderValueViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 11/21/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import JXSegmentedView
import MJRefresh
import SwiftyJSON
import UIKit

class HolderValueViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company?

    enum RequestType {
        case institutional
        case mutualFund
    }

    var requestType: RequestType = .institutional

    var holderProfiles = [HolderProfile]()

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(HolderProfileCell.self, forCellReuseIdentifier: "HolderProfileCell")
        tv.register(RowTitleHeader.self, forCellReuseIdentifier: "RowTitleHeader")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 8))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
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

        if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
            print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
        } else {
            if InterstitialAdsRequestHelper.increaseRequestAndCheckLoadInterstitialAd() {
                #if !targetEnvironment(macCatalyst)
                    GADInterstitialAd.load(withAdUnitID: Constants.GoogleAdsID.interstitialAdID, request: GADRequest()) { ad, error in
                        if let error = error {
                            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                            return
                        }
                        if let ad = ad {
                            ad.present(fromRootViewController: self)
                            InterstitialAdsRequestHelper.resetRequestCount()
                        } else {
                            print("interstitial Ad wasn't ready")
                        }
                    }
                #else
                    let moreAppsViewController = MoreAppsViewController()
                    moreAppsViewController.isAds = true
                    present(FGUINavigationController(rootViewController: moreAppsViewController), animated: true, completion: nil)
                    InterstitialAdsRequestHelper.resetRequestCount()
                #endif
            }
        }

        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fetchDataOnline))
        tableView.mj_header = header
        header.loadingView?.color = .white1
        header.stateLabel?.textColor = .white1
        header.lastUpdatedTimeLabel?.textColor = .white1

        tableView.mj_header?.beginRefreshing()
    }

    @objc private func fetchDataOnline() {
        guard let company = company else { return }
        startFetchData()
        var urlString = ""

        if requestType == .institutional {
            urlString = APIManager.baseURL + "/api/v3/institutional-holder/\(company.symbol)"
        } else {
            urlString = APIManager.baseURL + "/api/v3/mutual-fund-holder/\(company.symbol)"
        }

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)

                    var tempHolderProfiles = [HolderProfile]()

                    for dict in json.arrayValue {
                        tempHolderProfiles.append(HolderProfile(dict: dict))
                    }

                    tempHolderProfiles.sort { $0.shares > $1.shares }

                    self.holderProfiles = []
                    for (i, holderProfile) in tempHolderProfiles.enumerated() where i < 25 {
                        self.holderProfiles.append(holderProfile)
                    }

                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.holderProfiles.count == 0 {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.holderProfiles.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

extension HolderValueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + holderProfiles.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RowTitleHeader", for: indexPath) as! RowTitleHeader
            if requestType == .institutional {
                cell.titleText = "Institutional Holders (Top 25)".localized()
            } else {
                cell.titleText = "Mutual Fund Holders (Top 25)".localized()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HolderProfileCell", for: indexPath) as! HolderProfileCell
            cell.holderProfile = holderProfiles[indexPath.row - 1]
            return cell
        }
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate

extension HolderValueViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
