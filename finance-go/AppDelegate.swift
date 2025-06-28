//
//  AppDelegate.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/22/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import SwiftyJSON
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    #if !targetEnvironment(macCatalyst)
        var appOpenAd: GADAppOpenAd?
        var loadTime: Date = Date()
        var openTime = 0
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        #if !targetEnvironment(macCatalyst)
            let ads = GADMobileAds.sharedInstance()
            ads.start { status in
                // Optional: Log each adapter's initialization latency.
                let adapterStatuses = status.adapterStatusesByClassName
                for adapter in adapterStatuses {
                    let adapterStatus = adapter.value
                    NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
                          adapterStatus.description, adapterStatus.latency)
                }

                // Start loading ads here...
            }

            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["63b1a70cd43db3b79beea62431e646b4"]
        #endif

        StoreReviewHelper.incrementFetchCount()
        StoreReviewHelper.checkAndAskForReview()

        CompanyStore.shared.fetchLocalCompanies()

//        print(NSHomeDirectory())

        // After version 1.8.1, user userdefaults to store watch companies
        WatchCompanyHelper.transferWatchCompanyFromCoreDataToUserDefaultsIfNeeded()

        WatchCompanyHelper.initialDefaultWatchlist()

        fetchDataOnline()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.versionCheck()
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        #if !targetEnvironment(macCatalyst)
            requestATTPermission()
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                if IAPHelper.isPurchasing {
                    print("is purchasing")
                } else {
                    let rootViewController = application.windows.first(
                        where: { $0.isKeyWindow })?.rootViewController
                    if let rootViewController = rootViewController {
                        if Constants.Device.isPad {
                            print("openTime: \(openTime)")
                            if openTime >= 1 {
                                AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
                            }
                            openTime += 1
                        } else {
                            AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
                        }
                    }
                }
            }
        #endif
    }
}

extension AppDelegate {
    private func fetchDataOnline() {
        let urlString = APIManager.baseURL + "/api/v3/stock/list"
        NetworkManager.shared.request(
            urlString: urlString,
            parameters: APIManager.singleAPIKeyParameter,
            cacheExpire: .date(Date().addingTimeInterval(24 * 60 * 60)),
            fetchType: .cacheAndOnlineIfExpired) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                if response.isCache {
                    let json = JSON(data)
                    for objectJSON in json.arrayValue {
                        let company = Company(json: objectJSON)
                        if CompanyStore.shared.item(symbol: company.symbol) == nil {
                            CompanyStore.shared.add(company: company)
                        } else {
                            CompanyStore.shared.item(symbol: company.symbol)?.name = company.name
                            CompanyStore.shared.item(symbol: company.symbol)?.price = company.price
                        }
                    }
                } else {
                    DispatchQueue.background(qos: .userInteractive, background: {
                        let json = JSON(data)
                        for objectJSON in json.arrayValue {
                            let company = Company(json: objectJSON)
                            if CompanyStore.shared.item(symbol: company.symbol) == nil {
                                CompanyStore.shared.add(company: company)
                            } else {
                                CompanyStore.shared.item(symbol: company.symbol)?.name = company.name
                                CompanyStore.shared.item(symbol: company.symbol)?.price = company.price
                            }
                        }
                    })
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
        }
    }

    func versionCheck() {
        VersionCheck.shared.isUpdateAvailable { isAvailable, versionStore in
            if isAvailable {
                let alertController = UIAlertController(title: "New Version".localized(), message: "Update to the latest version".localized() + " (\(versionStore))?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok".localized(), style: .default) { _ in
                    if let reviewURL = URL(string: "https://itunes.apple.com/app/id\(Constants.appID)"), UIApplication.shared.canOpenURL(reviewURL) {
                        UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                    }
                })
                alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
                UIApplication.getTopMostViewController()?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// #if !targetEnvironment(macCatalyst)

//    // MARK: - App open ad related
//
//    extension AppDelegate: GADFullScreenContentDelegate {
//        func requestAppOpenAd() {
//            appOpenAd = nil
//            GADAppOpenAd.load(
//                withAdUnitID: Constants.GoogleAdsID.appOpenAdID,
//                request: GADRequest(),
//                orientation: .portrait) { appOpenAd, error in
//                if error != nil {
//                    print("Failed to load app open ad: \(String(describing: error))")
//                }
//                self.appOpenAd = appOpenAd
//                self.appOpenAd?.fullScreenContentDelegate = self
//                self.loadTime = Date()
//            }
//        }
//
//        func tryToPresentAd() {
//            let ad = appOpenAd
//            appOpenAd = nil
//            if ad != nil && wasLoadTimeLessThanNHoursAgo(n: 4) {
//                if let rootViewController = window?.rootViewController {
//                    ad?.present(fromRootViewController: rootViewController)
//                }
//            } else {
//                requestAppOpenAd()
//            }
//        }
//
//        func wasLoadTimeLessThanNHoursAgo(n: Int) -> Bool {
//            let now = Date()
//            let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(loadTime)
//            let secondsPerHour = 3600.0
//            let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
//            return intervalInHours < Double(n)
//        }
//
//        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//            print("didFailToPresentFullSCreenCContentWithError")
//            requestAppOpenAd()
//        }
//
//        func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//            print("adDidPresentFullScreenContent")
//        }
//
//        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//            print("adDidDismissFullScreenContent")
//            requestAppOpenAd()
//        }
//    }
// #endif

#if targetEnvironment(macCatalyst)
    extension AppDelegate {
        override func buildMenu(with builder: UIMenuBuilder) {
            super.buildMenu(with: builder)
            builder.remove(menu: .help)
            builder.remove(menu: .format)
        }
    }
#endif
