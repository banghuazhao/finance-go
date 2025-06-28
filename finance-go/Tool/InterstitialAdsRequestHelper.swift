//
//  InterstitialAdsRequestHelper.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/1/13.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

struct InterstitialAdsRequestHelper {
    #if !targetEnvironment(macCatalyst)
        static let requestThreshold = 7
    #else
        static let requestThreshold = 4
    #endif

    static func incrementRequestCount() {
        if var requestCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.timesToOpenInterstitialAds) as? Int {
            requestCount += 1
            UserDefaults.standard.setValue(requestCount, forKey: UserDefaultsKeys.timesToOpenInterstitialAds)
        } else {
            UserDefaults.standard.setValue(1, forKey: UserDefaultsKeys.timesToOpenInterstitialAds)
        }
    }

    static func increaseRequestAndCheckLoadInterstitialAd() -> Bool {
        incrementRequestCount()
        let requestCount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.timesToOpenInterstitialAds)
        print("requestCount: \(requestCount)")
        if requestCount >= requestThreshold {
            return true
        }
        return false
    }

    static func resetRequestCount() {
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.timesToOpenInterstitialAds)
        print("resetRequestCount")
    }
}
