//
//  Constants.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

struct Constants {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    static let deviceName = modelIdentifier()
    static let iOSVersion = UIDevice.current.systemVersion
    static let regionCode = NSLocale.current.regionCode ?? "?"
    static let timeZone = TimeZone.current.identifier

    // This is a free account API key. Replace with your API key
    static let APIKey = "Sl3KekCBLRBGoFYGZO24KhiKTsTDg6ZA"

    static let facebookPageID = "104357371640600"
    static let appID = "1519476344"

    struct AppID {
        static let financeGoAppID = "1519476344"
        static let finanicalRatiosGoMacOSAppID = "1486184864"
        static let financialRatiosGoAppID = "1481582303"
        static let countdownDaysAppID = "1525084657"
        static let moneyTrackerAppID = "1534244892"
        static let BMIDiaryAppID = "1521281509"
        static let novelsHubAppID = "1528820845"
        static let nasaLoverID = "1595232677"
        static let mechanicalEngineeringToolkitID = "1601099443"
    }

    struct GoogleAdsID {
        // ca-app-pub-4766086782456413~9322287912

        #if DEBUG
            static let bannerViewAdUnitID = "ca-app-pub-3940256099942544/2934735716"
            static let interstitialAdID = "ca-app-pub-3940256099942544/1033173712"
            static let nativeAdID = "ca-app-pub-3940256099942544/3986624511"
            static let rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"
            static let appOpenAdID = "ca-app-pub-3940256099942544/5575463023"
        #else
            // These are demo Ads ID. Replace with your Ads ID
            static let bannerViewAdUnitID = "ca-app-pub-3940256099942544/2934735716"
            static let interstitialAdID = "ca-app-pub-3940256099942544/1033173712"
            static let nativeAdID = "ca-app-pub-3940256099942544/3986624511"
            static let rewardAdUnitID = "ca-app-pub-3940256099942544/1712485313"
            static let appOpenAdID = "ca-app-pub-3940256099942544/5575463023"
        #endif
    }

    struct Device {
        static let isIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone
        static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    }

    static let cacheDirectory: URL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("com.Cache.default")

    static let cacheFolderName = "FGCache"

    static let navBarPortraitHeight: CGFloat = 88

    static var graphBottomAdsSpaceHeight: CGFloat {
        if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
            return 0
        } else {
            if UIApplication.shared.statusBarOrientation.isPortrait {
                return 80
            } else {
                return 70
            }
        }
    }

    static let exchangeDict = [
        ("All (27357)", "All"),
        ("Nasdaq Global Select (12028)", "Nasdaq Global Select"),
        ("LSE (4438)", ".L"),
        ("HKSE (2310)", ".HK"),
        ("Toronto (1973)", ".TO"),
        ("ASX (1945)", ".AX"),
        ("NSE (1628)", ".NS"),
        ("Paris (893)", ".PA"),
        ("XETRA (876)", ".DE"),
        ("SIX (529)", ".SW"),
        ("MCX (216)", ".ME"),
        ("OSE (194)", ".OL"),
        ("Brussels (167)", ".BR"),
        ("Ansterdan (135)", ".AS"),
        ("Lisbon (55)", ".LS"),
    ]
}

struct UserDefaultsKeys {
    static let FETCH_COUNT = "FETCH_COUNT"
    static let timesToOpenInterstitialAds = "timesToOpenInterstitialAds"
}
