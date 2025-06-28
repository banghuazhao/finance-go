//
//  MoreAppsViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 1/1/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import UIKit

class MoreAppsViewController: FGUIViewController {
    var isAds: Bool = false

    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()

        let appItems = [
            AppItem(
                title: "Financial Ratios Go".localized(),
                detail: "Finance, Ratios, Investing".localized(),
                icon: UIImage(named: "appIcon_financial_ratios_go"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.financialRatiosGoAppID)")),
            AppItem(
                title: "TripMark".localized(),
                detail: "Trip & Travel Planner".localized(),
                icon: UIImage(named: "tripmark"),
                url: URL(string: "http://itunes.apple.com/app/id6464474080")),
            AppItem(
                title: "SwiftSum".localized(),
                detail: "Simple Calculator".localized(),
                icon: UIImage(named: "swiftsum"),
                url: URL(string: "http://itunes.apple.com/app/id1610829871")),
            AppItem(
                title: "Easy Unit".localized(),
                detail: "Unit-Conversion".localized(),
                icon: UIImage(named: "easy_unit"),
                url: URL(string: "http://itunes.apple.com/app/id1643640909")),
            AppItem(
                title: "Money Tracker".localized(),
                detail: "Budget, Expense & Bill Planner".localized(),
                icon: UIImage(named: "appIcon_money_tracker"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.moneyTrackerAppID)")),
           AppItem(
                title: "Relaxing Up".localized(),
                detail: "Meditation&Healing".localized(),
                icon: UIImage(named: "relaxing_up"),
                url: URL(string: "http://itunes.apple.com/app/id1618712178")),
            AppItem(
                title: "Image Guru".localized(),
                detail: "Photo Editor,Filter".localized(),
                icon: UIImage(named: "image_guru"),
                url: URL(string: "http://itunes.apple.com/app/id1625021625")),
            AppItem(
                title: "Yes Habit".localized(),
                detail: "Habit Tracker".localized(),
                icon: UIImage(named: "yes_habit"),
                url: URL(string: "http://itunes.apple.com/app/id1637643734")),
            AppItem(
                title: "Instant Face".localized(),
                detail: "Avatar Maker".localized(),
                icon: UIImage(named: "instant_face"),
                url: URL(string: "http://itunes.apple.com/app/id1638563222")),
            AppItem(
                title: "We Play Piano".localized(),
                detail: "Piano Keyboard".localized(),
                icon: UIImage(named: "we_play_piano"),
                url: URL(string: "http://itunes.apple.com/app/id1625018611")),
            AppItem(
                title: "Novels Hub".localized(),
                detail: "Fiction eBooks Library!".localized(),
                icon: UIImage(named: "appIcon_novels_Hub"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.novelsHubAppID)")),
            AppItem(
                title: "World Weather Live".localized(),
                detail: "All Cities".localized(),
                icon: UIImage(named: "world_weather_live"),
                url: URL(string: "http://itunes.apple.com/app/id1612773646")),
            AppItem(
                title: "Water Tracker".localized(),
                detail: "Drink Water Log".localized(),
                icon: UIImage(named: "water_tracker"),
                url: URL(string: "http://itunes.apple.com/app/id1534891702")),
            AppItem(
                title: "Sudoku Lover".localized(),
                detail: "Sudoku Lover".localized(),
                icon: UIImage(named: "sudoku_lover"),
                url: URL(string: "http://itunes.apple.com/app/id1620749798")),
            AppItem(
                title: "BMI Diary".localized(),
                detail: "Fitness, Weight Loss &Health".localized(),
                icon: UIImage(named: "appIcon_bmiDiary"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.BMIDiaryAppID)")),
            AppItem(
                title: "Universe Lover".localized(),
                detail: "Explore Space & Astronomy News".localized(),
                icon: UIImage(named: "appicon_nasa_lover"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.nasaLoverID)")),
            AppItem(
                title: "More Apps".localized(),
                detail: "Check out more Apps made by us".localized(),
                icon: UIImage(named: "appIcon_appStore"),
                url: URL(string: "https://apps.apple.com/us/developer/%E7%92%90%E7%92%98-%E6%9D%A8/id1599035519")),
        ]
    #else
        let appItems = [
            AppItem(
                title: "Ratios Go".localized(),
                detail: "Finance, Ratios, Investing".localized(),
                icon: UIImage(named: "appIcon_financial_ratios_go"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.finanicalRatiosGoMacOSAppID)")),
            AppItem(
                title: "Money Tracker".localized(),
                detail: "Budget, Expense & Bill Planner".localized(),
                icon: UIImage(named: "appIcon_money_tracker"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.moneyTrackerAppID)")),
            AppItem(
                title: "BMI Diary".localized(),
                detail: "Fitness, Weight Loss &Health".localized(),
                icon: UIImage(named: "appIcon_bmiDiary"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.BMIDiaryAppID)")),
            AppItem(
                title: "Novels Hub".localized(),
                detail: "Fiction eBooks Library!".localized(),
                icon: UIImage(named: "appIcon_novels_Hub"),
                url: URL(string: "http://itunes.apple.com/app/id\(Constants.AppID.novelsHubAppID)")),
            AppItem(
                title: "More Apps".localized(),
                detail: "Check out more Apps made by us".localized(),
                icon: UIImage(named: "appIcon_appStore"),
                url: URL(string: "https://apps.apple.com/us/developer/%E7%92%90%E7%92%98-%E6%9D%A8/id1599035519")),
        ]
    #endif

    lazy var tableView = UITableView().then { tv in
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(AppItemCell.self, forCellReuseIdentifier: "AppItemCell")
        tv.register(MoreAppsHeaderCell.self, forCellReuseIdentifier: "MoreAppsHeaderCell")
        tv.register(MoreAppsRemoveAdsCell.self, forCellReuseIdentifier: "MoreAppsRemoveAdsCell")
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.separatorColor = UIColor.white3
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isAds {
            title = "More Apps (Ads)".localized()

            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named: "back_button"), for: .normal)
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        } else {
            title = "More Apps".localized()
        }

        view.addSubview(tableView)

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                view.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(50)
                }
            }
        #endif

        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MoreAppsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isAds {
            return 3
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAds {
            if section == 0 {
                return 1
            } else if section == 1 {
                return 1
            } else {
                return appItems.count
            }
        } else {
            if section == 0 {
                return 1
            } else {
                return appItems.count
            }
        }
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return .zero
//        } else {
//            return 50 + 16 + 16
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAds {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoreAppsRemoveAdsCell", for: indexPath) as! MoreAppsRemoveAdsCell
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoreAppsHeaderCell", for: indexPath) as! MoreAppsHeaderCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppItemCell", for: indexPath) as! AppItemCell
                cell.appItem = appItems[indexPath.row]
                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoreAppsHeaderCell", for: indexPath) as! MoreAppsHeaderCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppItemCell", for: indexPath) as! AppItemCell
                cell.appItem = appItems[indexPath.row]
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAds {
            if indexPath.section == 0 {
                navigationController?.pushViewController(RemoveAdsViewController(), animated: true)
            } else if indexPath.section == 1 {
                return
            } else {
                let appItem = appItems[indexPath.row]
                if let url = appItem.url, UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else {
            if indexPath.section == 0 {
                return
            } else {
                let appItem = appItems[indexPath.row]
                if let url = appItem.url, UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
