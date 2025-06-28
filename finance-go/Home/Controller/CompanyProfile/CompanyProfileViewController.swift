//
//  CompanyProfileViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

import SwiftyJSON
import UIKit

class CompanyProfileViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company? {
        didSet {
            dataSource = [company]
        }
    }

    var dataSource = [Any?]()
    
    var activityIndicator = UIActivityIndicatorView().then { indicator in
        if #available(iOS 13.0, *) {
            indicator.style = .large
            indicator.color = .white
        } else {
            indicator.style = .white
        }
    }

    var companyProfile: CompanyProfile? {
        didSet {
            guard let companyProfile = companyProfile else {
                return
            }
            let twoColumnTitleValues = [
                TwoColumnTitleValue(
                    title1: "CEO",
                    value1: companyProfile.ceo,
                    title2: "IPO Date".localized(),
                    value2: companyProfile.ipoDate),
                TwoColumnTitleValue(
                    title1: "Full Time Employees".localized(),
                    value1: companyProfile.fullTimeEmployees,
                    title2: "Exchange".localized(),
                    value2: companyProfile.exchange),
                TwoColumnTitleValue(
                    title1: "Sector".localized(),
                    value1: companyProfile.sector,
                    title2: "Industry".localized(),
                    value2: companyProfile.industry),
                TwoColumnTitleValue(
                    title1: "Address".localized(),
                    value1: companyProfile.address,
                    title2: "City".localized(),
                    value2: companyProfile.city),
                TwoColumnTitleValue(
                    title1: "State".localized(),
                    value1: companyProfile.state,
                    title2: "ZIP".localized(),
                    value2: companyProfile.zip),
                TwoColumnTitleValue(
                    title1: "Country".localized(),
                    value1: companyProfile.country,
                    title2: "Website".localized(),
                    value2: companyProfile.website,
                    isLink2: true)]
            dataSource.append(contentsOf: twoColumnTitleValues)
            dataSource.append(companyProfile)
        }
    }

    override var isStaticBackground: Bool {
        return true
    }

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyProfileHeaderCell.self, forCellReuseIdentifier: "CompanyProfileHeaderCell")
        tv.register(TwoColumnTitleValueCell.self, forCellReuseIdentifier: "TwoColumnTitleValueCell")
        tv.register(CompanyProfileDescriptionCell.self, forCellReuseIdentifier: "CompanyProfileDescriptionCell")
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = true
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        tv.keyboardDismissMode = .onDrag
    }

    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Company Profile".localized()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:)))

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.top.equalToSuperview()
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

        fetchData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CompanyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.row]
        if let model = data as? Company {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyProfileHeaderCell", for: indexPath) as! CompanyProfileHeaderCell
            cell.company = model
            return cell
        } else if let model = data as? TwoColumnTitleValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoColumnTitleValueCell", for: indexPath) as! TwoColumnTitleValueCell
            cell.twoColumnTitleValue = model
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyProfileDescriptionCell", for: indexPath) as! CompanyProfileDescriptionCell
            cell.companyProfile = data as? CompanyProfile
            return cell
        }
    }
}

// MARK: - fetch data

extension CompanyProfileViewController {
    func fetchData() {
        guard let symbol = company?.symbol else { return }
        let urlString = APIManager.baseURL + "/api/v3/profile/\(symbol)"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(7 * 24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                if let json = JSON(data).arrayValue.first {
                    self.companyProfile = CompanyProfile(json: json)
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }
}

// MARK: - actions

extension CompanyProfileViewController {
    @objc func share(_ sender: UIBarButtonItem) {
        print("shareCompanyProfile")

        guard let company = company, let companyProfile = companyProfile else { return }

        var str: String = ""

        str += "Company Profile".localized()

        str += "\n\n"

        str += "\("Company Name".localized()):\t\(company.name)\n"

        str += "\n"

        str += "\("Company Symbol".localized()):\t\(company.symbol)\n"

        str += "\n"

        str += "\("CEO"):\t\(companyProfile.ceo)\n\n"
        str += "\("IPO Date".localized()):\t\(companyProfile.ipoDate)\n\n"
        str += "\("Full Time Employees".localized()):\t\(companyProfile.fullTimeEmployees)\n\n"
        str += "\("Exchange".localized()):\t\(companyProfile.exchange)\n\n"
        str += "\("Sector".localized()):\t\(companyProfile.sector)\n\n"
        str += "\("Industry".localized()):\t\(companyProfile.industry)\n\n"
        str += "\("Address".localized()):\t\(companyProfile.address)\n\n"
        str += "\("City".localized()):\t\(companyProfile.city)\n\n"
        str += "\("State".localized()):\t\(companyProfile.state)\n\n"
        str += "\("ZIP"):\t\(companyProfile.zip)\n\n"
        str += "\("Country".localized()):\t\(companyProfile.country)\n\n"
        str += "\("Website".localized()):\t\(companyProfile.website)\n\n"
        str += "\("Description".localized()):\t\(companyProfile.description)\n\n"

        let file = getDocumentsDirectory().appendingPathComponent("\("Company Profile".localized()) \(company.symbol).txt")

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create Company Profile.txt: \(err)")
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

extension CompanyProfileViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y > CGFloat(60) {
            if let symbol = company?.symbol {
                title = symbol
            }
        } else {
            title = "Company Profile".localized()
        }
    }
}
