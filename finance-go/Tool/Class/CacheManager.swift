//
//  CacheManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/18.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import Cache

class CacheManager {
    static let shared = CacheManager()
    
    var storage: Storage<String, Data>? {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(
                name: Constants.cacheFolderName,
                expiry: .date(Date().addingTimeInterval(7 * 60 * 60)),
                directory: Constants.cacheDirectory),
            memoryConfig: MemoryConfig(
                expiry: .date(Date().addingTimeInterval(7 * 60 * 60))),
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }
}
