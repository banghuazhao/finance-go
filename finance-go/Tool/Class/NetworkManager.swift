//
//  NetworkManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/18.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Alamofire
import Cache
import Foundation

class BZResponse {
    let isCache: Bool
    let result: AFResult<Data>
    var cacheExpire: Expiry? = nil
    
    init(isCache: Bool, result: AFResult<Data>) {
        self.isCache = isCache
        self.result = result
    }
    
    init(isCache: Bool, cacheExpire: Expiry?, result: AFResult<Data>) {
        self.isCache = isCache
        self.result = result
        self.cacheExpire = cacheExpire
    }
}

class NetworkManager {
    static let shared = NetworkManager()

    enum FetchType {
        case online
        case cacheAndOnline
        case cacheAndOnlineIfExpired
        case cacheOrOnline
    }

    private func queryString(urlString: String, paramsters: [String: String]) -> String {
        var components = URLComponents(string: urlString)
        components?.queryItems = paramsters.map { element in URLQueryItem(name: element.key, value: element.value) }
        if let queryString = components?.url?.absoluteString {
            return queryString
        } else {
            var queryString = urlString
            for (key, val) in paramsters {
                queryString += key + val
            }
            return queryString
        }
    }

    func request(
        urlString: String,
        parameters: [String: String],
        cacheExpire: Expiry,
        fetchType: FetchType,
        completion: @escaping (BZResponse) -> Void) {
        let cacheKey = queryString(urlString: urlString, paramsters: parameters)
        print(cacheKey)

        if fetchType == .online {
            AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                completion(response)
            }
        } else if fetchType == .cacheAndOnline {
            if let data = try? CacheManager.shared.storage?.object(forKey: cacheKey) {
                completion(BZResponse(isCache: true, result: AFResult.success(data)))
            }
            AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                completion(response)
            }
        } else if fetchType == .cacheAndOnlineIfExpired {
            if let data = try? CacheManager.shared.storage?.object(forKey: cacheKey) {
                let cacheExpireData = try? CacheManager.shared.storage?.entry(forKey: cacheKey).expiry
                completion(BZResponse(isCache: true, cacheExpire: cacheExpireData, result: AFResult.success(data)))
                if let expire = try? CacheManager.shared.storage?.isExpiredObject(forKey: cacheKey), expire == true {
                    AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                        completion(response)
                    }
                }
            } else {
                AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                    completion(response)
                }
            }
        } else if fetchType == .cacheOrOnline {
            if let data = try? CacheManager.shared.storage?.object(forKey: cacheKey) {
                if let expire = try? CacheManager.shared.storage?.isExpiredObject(forKey: cacheKey), expire == true {
                    AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                        completion(response)
                    }
                } else {
                    completion(BZResponse(isCache: true, result: AFResult.success(data)))
                }
            } else {
                AFRequest(urlString: urlString, parameters: parameters, cacheExpire: cacheExpire, cacheKey: cacheKey) { response in
                    completion(response)
                }
            }
        }
    }

    private func AFRequest(urlString: String, parameters: [String: String], cacheExpire: Expiry, cacheKey: String, completion: @escaping (BZResponse) -> Void) {
        AF.request(urlString, parameters: parameters).responseData { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case let .success(data):
                if !cacheExpire.isExpired {
                    try? CacheManager.shared.storage?.setObject(data, forKey: cacheKey, expiry: cacheExpire)
                }
            case let .failure(error):
                print("\(String(describing: type(of: self))) Network error:", error)
            }
            completion(BZResponse(isCache: false, result: response.result))
        }
    }
}
