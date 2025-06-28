//
//  TabbarController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 9/13/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Alamofire
import Cache
import Localize_Swift
import PPBadgeViewSwift
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = true
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        tabBar.unselectedItemTintColor = .white2
        tabBar.backgroundColor = .tabBarColor
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()

        #if !targetEnvironment(macCatalyst)
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.compactInlineLayoutAppearance.normal.iconColor = .white2
                appearance.inlineLayoutAppearance.normal.iconColor = .white2
                appearance.stackedLayoutAppearance.normal.iconColor = .white2
                appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white2]
                appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white2]
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white2]
                appearance.backgroundColor = .tabBarColor
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = appearance
            }
        #endif

        let companiesViewController = FGUINavigationController(rootViewController: HomeViewController())
        companiesViewController.tabBarItem.title = "Home".localized()
        companiesViewController.tabBarItem.image = UIImage(named: "tab_house")
        companiesViewController.tabBarItem.selectedImage = UIImage(named: "tab_house_selected")

        let newsViewController = FGUINavigationController(rootViewController: NewsContainerViewController())
        newsViewController.tabBarItem.title = "News".localized()
        newsViewController.tabBarItem.image = UIImage(named: "tab_news")
        newsViewController.tabBarItem.selectedImage = UIImage(named: "tab_news_selected")

        let calendarsItemViewController = FGUINavigationController(rootViewController: CalendarsViewController())
        calendarsItemViewController.tabBarItem.title = "Calendars".localized()
        calendarsItemViewController.tabBarItem.image = UIImage(named: "calendars")
        calendarsItemViewController.tabBarItem.selectedImage = UIImage(named: "calendars-selected")
        calendarsItemViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

        let moreViewController = FGUINavigationController(rootViewController: MoreViewController())
        moreViewController.tabBarItem.title = "More".localized()
        moreViewController.tabBarItem.image = UIImage(named: "tab_more_circle")
        moreViewController.tabBarItem.selectedImage = UIImage(named: "tab_more_circle_selected")

        setViewControllers([companiesViewController, newsViewController, calendarsItemViewController, moreViewController], animated: true)

        checkBadge()
    }
}

extension TabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        item.pp.hiddenBadge()
    }

    func addBadge(index: Int) {
        tabBar.items?[index].pp.addBadge(text: "")
        tabBar.items?[index].pp.setBadge(height: 10)
        tabBar.items?[index].pp.showBadge()
    }

    private func checkBadge() {
        let urlNews = "https://financialmodelingprep.com/api/v3/stock_news?apikey=\(Constants.APIKey)"

        if let data = try? CacheManager.shared.storage?.object(forKey: urlNews) {
            if let expire = try? CacheManager.shared.storage?.isExpiredObject(forKey: urlNews), expire == true {
                AF.request(urlNews).responseData { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case let .success(newData):
                        if data != newData {
                            self.addBadge(index: 1)
                        }
                    case let .failure(error):
                        print("\(String(describing: type(of: self))) Network error:", error)
                    }
                }
            }
        } else {
            addBadge(index: 1)
        }

        let urlCalendar = "https://financialmodelingprep.com/api/v3/earning_calendar?apikey=\(Constants.APIKey)"
        if let data = try? CacheManager.shared.storage?.object(forKey: urlCalendar) {
            if let expire = try? CacheManager.shared.storage?.isExpiredObject(forKey: urlCalendar), expire == true {
                AF.request(urlCalendar).responseData { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case let .success(newData):
                        if data != newData {
                            self.addBadge(index: 2)
                        }
                    case let .failure(error):
                        print("\(String(describing: type(of: self))) Network error:", error)
                    }
                }
            }
        } else {
            addBadge(index: 2)
        }
    }
}
