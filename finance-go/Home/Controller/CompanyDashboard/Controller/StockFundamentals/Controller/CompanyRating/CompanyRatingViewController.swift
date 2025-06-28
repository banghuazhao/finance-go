//
//  FinancialGrowthViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Hue
import Localize_Swift
import SnapKit
import Then
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class CompanyRatingViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    var company: Company!

    var storage: Storage<String, Data>? {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(name: "CompanyRating", expiry: .date(Date().addingTimeInterval(12 * 60 * 60)), directory: Constants.cacheDirectory),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }

    var cacheKey: String {
        "https://financialmodelingprep.com/api/v3/rating/\(company.symbol)"
    }

    var companyRating: CompanyRating = CompanyRating(
        date: "Downloading",
        rating: "",
        ratingScore: 0,
        ratingRecommendation: "Downloading",
        ratingDetailsDCFScore: 0,
        ratingDetailsDCFRecommendation: "Downloading",
        ratingDetailsROEScore: 0,
        ratingDetailsROERecommendation: "Downloading",
        ratingDetailsROAScore: 0,
        ratingDetailsROARecommendation: "Downloading",
        ratingDetailsDEScore: 0,
        ratingDetailsDERecommendation: "Downloading",
        ratingDetailsPEScore: 0,
        ratingDetailsPERecommendation: "Downloading",
        ratingDetailsPBScore: 0,
        ratingDetailsPBRecommendation: "Downloading")

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(CompanyRatingCell.self, forCellReuseIdentifier: "CompanyRatingCell")
        tv.separatorStyle = .none
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Company Rating".localized()
        
        let infoButton = UIButtonLargerTouchArea(type: .custom).then { b in
            b.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
            b.addTarget(self, action: #selector(infoTapped), for: .touchUpInside)
            b.tintColor = .white1
            b.snp.makeConstraints { make in
                make.size.equalTo(24)
            }
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "navItem_share"), style: .plain, target: self, action: #selector(share(_:))),
            UIBarButtonItem(customView: infoButton)
            ]

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
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

        fetchData()
    }

    private func fetchData() {
        // check if there is cache
        if let data = try? storage?.object(forKey: cacheKey) {
            setData(data: data)

            // if there is cache, check if it is expried
            if let expire = try? storage?.isExpiredObject(forKey: cacheKey), expire == true {
                fetchDataOnline()
            }
        } else {
            // if there is no cache, fetch online and create cache
            fetchDataOnline()
        }
    }

    private func fetchDataOnline() {
        guard let urlString1 = "https://financialmodelingprep.com/api/v3/rating/\(company.symbol)?apikey=\(Constants.APIKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url1 = URL(string: urlString1) else { return }

        URLSession(configuration: .default).dataTask(with: url1) { data, _, err in
            if let err = err {
                if err._code == NSURLErrorTimedOut {
                    print("Time Out: \(err)")
                    return
                } else if err._code == NSURLErrorCancelled {
                    print("Network Cancelled: \(err)")
                    return
                }
                print("Network Error: \(err)")
                return
            }

            guard let data = data else {
                return
            }

            do {
                try self.storage?.setObject(data, forKey: self.cacheKey)

                self.setData(data: data)

            } catch let error {
                print("error: \(error)")
                return
            }
        }.resume()
    }

    func setData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let financialDicts = json as? [[String: Any]] else {
                return
            }
            if financialDicts.count > 0 {
                let finanaicalDict = financialDicts[0]

                companyRating.date = finanaicalDict["date"] as? String ?? "No Data"
                companyRating.rating = finanaicalDict["rating"] as? String ?? "?"
                companyRating.ratingScore = finanaicalDict["ratingScore"] as? Int ?? 0
                companyRating.ratingRecommendation = finanaicalDict["ratingRecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsDCFScore = finanaicalDict["ratingDetailsDCFScore"] as? Int ?? 0
                companyRating.ratingDetailsDCFRecommendation = finanaicalDict["ratingDetailsDCFRecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsROEScore = finanaicalDict["ratingDetailsROEScore"] as? Int ?? 0
                companyRating.ratingDetailsROERecommendation = finanaicalDict["ratingDetailsROERecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsROAScore = finanaicalDict["ratingDetailsROAScore"] as? Int ?? 0
                companyRating.ratingDetailsROARecommendation = finanaicalDict["ratingDetailsROARecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsDEScore = finanaicalDict["ratingDetailsDEScore"] as? Int ?? 0
                companyRating.ratingDetailsDERecommendation = finanaicalDict["ratingDetailsDERecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsPEScore = finanaicalDict["ratingDetailsPEScore"] as? Int ?? 0
                companyRating.ratingDetailsPERecommendation = finanaicalDict["ratingDetailsPERecommendation"] as? String ?? "No Data"
                companyRating.ratingDetailsPBScore = finanaicalDict["ratingDetailsPBScore"] as? Int ?? 0
                companyRating.ratingDetailsPBRecommendation = finanaicalDict["ratingDetailsPBRecommendation"] as? String ?? "No Data"
            } else {
                companyRating.date = "No Data"
                companyRating.rating = "No Data"
                companyRating.ratingScore = 0
                companyRating.ratingRecommendation = "No Data"
                companyRating.ratingDetailsDCFScore = 0
                companyRating.ratingDetailsDCFRecommendation = "No Data"
                companyRating.ratingDetailsROEScore = 0
                companyRating.ratingDetailsROERecommendation = "No Data"
                companyRating.ratingDetailsROAScore = 0
                companyRating.ratingDetailsROARecommendation = "No Data"
                companyRating.ratingDetailsDEScore = 0
                companyRating.ratingDetailsDERecommendation = "No Data"
                companyRating.ratingDetailsPEScore = 0
                companyRating.ratingDetailsPERecommendation = "No Data"
                companyRating.ratingDetailsPBScore = 0
                companyRating.ratingDetailsPBRecommendation = "No Data"
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let jsonError {
            print("Parse JSON error: \(jsonError)")
            return
        }
    }
}

extension CompanyRatingViewController {
    @objc func infoTapped() {
        navigationController?.pushViewController(CompanyRatingExplainViewController(), animated: true) 
    }

    @objc func share(_ sender: UIBarButtonItem) {
        var str: String = ""

        str += "\("Company".localized()):\t\(company.name) (\(company.symbol))\n"

        str += "\("Date".localized()):\t\(companyRating.date)\n"

        str += "\n"

        str += "\("Company Rating".localized()):\n"

        str += "\n"

        str += "Rating: \(companyRating.rating) \n"
        str += "Overall Score: \(companyRating.ratingScore) \n"
        str += "Overall Recommendation: \(companyRating.ratingRecommendation) \n"
        str += "DCF Score: \(companyRating.ratingDetailsDCFScore) \n"
        str += "DCF Recommendation: \(companyRating.ratingDetailsDCFRecommendation) \n"
        str += "ROE Score: \(companyRating.ratingDetailsROEScore) \n"
        str += "ROE Recommendation: \(companyRating.ratingDetailsROERecommendation) \n"
        str += "ROA Score: \(companyRating.ratingDetailsROAScore) \n"
        str += "ROA Recommendation: \(companyRating.ratingDetailsROARecommendation) \n"
        str += "DE Score: \(companyRating.ratingDetailsDEScore) \n"
        str += "DE Recommendation: \(companyRating.ratingDetailsDERecommendation) \n"
        str += "PE Score: \(companyRating.ratingDetailsPEScore) \n"
        str += "PE Recommendation: \(companyRating.ratingDetailsPERecommendation) \n"
        str += "PB Score: \(companyRating.ratingDetailsPBScore) \n"
        str += "PB Recommendation: \(companyRating.ratingDetailsPBRecommendation) \n"

        str += "\n"

        let file = getDocumentsDirectory().appendingPathComponent("\("Company Rating".localized()) \(company.symbol).txt")

        do {
            try str.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch let err {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("Error when create company_rating.txt: \(err)")
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

extension CompanyRatingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108 + 88 + 80 * 7 + 24
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyRatingCell", for: indexPath) as! CompanyRatingCell

        cell.companyRating = companyRating

        return cell
    }
}
