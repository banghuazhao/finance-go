//
//  VersionCheck.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/11.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Alamofire
import SwiftyJSON

class VersionCheck {
    public static let shared = VersionCheck()

    func isUpdateAvailable(callback: @escaping (Bool, String) -> Void) {
        guard let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            callback(false, "")
            return
        }
        AF.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
            switch response.result {
            case let .success(data):
                if let json = data as? NSDictionary, let results = json["results"] as? NSArray, let entry = results.firstObject as? NSDictionary, let versionStore = entry["version"] as? String, let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    
                    let arrayStore = versionStore.split(separator: ".")
                    let arrayLocal = versionLocal.split(separator: ".")

                    print("arrayStore: \(arrayStore), arrayLocal: \(arrayLocal)")

                    
                    if arrayLocal.count != arrayStore.count {
                        callback(true, versionStore) // different versioning system
                    }

                    // check each segment of the version
                    for (key, value) in arrayLocal.enumerated() {
                        if let v1 = Int(value), let v2 = Int(arrayStore[key]), v1 < v2 {
                            callback(true, versionStore)
                            return
                        } else {
                            callback(false, "")
                            return
                        }
                    }
                }
                callback(false, "") // no new version or failed to fetch app store version
            case let .failure(error):
                print("VersionCheck error: ", error)
            }
        }
    }
}
