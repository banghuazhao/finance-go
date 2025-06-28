//
//  APIManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    static let singleAPIKeyParameter = ["apikey": Constants.APIKey]
    static let baseURL = "https://financialmodelingprep.com"
}
