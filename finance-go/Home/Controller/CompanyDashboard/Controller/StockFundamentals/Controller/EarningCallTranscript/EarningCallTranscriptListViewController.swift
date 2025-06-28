//
//  EarningCallTranscriptListViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/31.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import Cache
import MJRefresh
import SwiftyJSON
import UIKit

class EarningCallTranscriptListViewController: FGUIViewController {
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

    var earningCallTranscriptDates = [EarningCallTranscriptDate]()

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(EarningCallTranscriptDateCell.self, forCellReuseIdentifier: "EarningCallTranscriptDateCell")
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        tv.separatorColor = .white3
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 16))
        tv.alwaysBounceVertical = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initStateViews()

        title = "Earning Call Transcript".localized()

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

extension EarningCallTranscriptListViewController {
    @objc func fetchDataOnline() {
        guard let company = company else { return }
        startFetchData()
        let urlString = APIManager.baseURL + "/api/v4/earning_call_transcript"

        let parameters = [
            "symbol": company.symbol,
            "apikey": Constants.APIKey,
        ]

        NetworkManager.shared.request(
            urlString: urlString,
            parameters: parameters,
            cacheExpire: .date(Date().addingTimeInterval(7 * 24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                DispatchQueue.background {
                    let json = JSON(data)

                    var earningCallTranscriptDatesTemp = [EarningCallTranscriptDate]()
                    for temp in json.arrayValue {
                        earningCallTranscriptDatesTemp.append(EarningCallTranscriptDate(list: temp))
                    }
                    self.earningCallTranscriptDates = earningCallTranscriptDatesTemp
                } completion: {
                    self.tableView.reloadData()
                    self.tableView.mj_header?.endRefreshing()
                    if self.earningCallTranscriptDates.count == 0 {
                        self.showNoData()
                    }
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
                self.tableView.mj_header?.endRefreshing()
                if self.earningCallTranscriptDates.count == 0 {
                    self.showNetworkError()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension EarningCallTranscriptListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earningCallTranscriptDates.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarningCallTranscriptDateCell", for: indexPath) as! EarningCallTranscriptDateCell

        cell.earningCallTranscriptDate = earningCallTranscriptDates[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let earningCallTranscriptViewController = EarningCallTranscriptViewController()
        earningCallTranscriptViewController.company = company
        earningCallTranscriptViewController.earningCallTranscriptDate = earningCallTranscriptDates[indexPath.row]
        navigationController?.pushViewController(earningCallTranscriptViewController, animated: true)
    }
}
