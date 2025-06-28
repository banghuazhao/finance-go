//
//  CompanyQuote.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompanyQuote {
    let symbol: String?
    let name: String?
    let price: Double?
    let changesPercentage: Double?
    let change: Double?
    let dayLow: Double?
    let dayHigh: Double?
    let yearHigh: Double?
    let yearLow: Double?
    let marketCap: Double?
    let priceAvg50: Double?
    let priceAvg200: Double?
    let volume: Double?
    let avgVolume: Double?
    let exchange: String?
    let open: Double?
    let previousClose: Double?
    let eps: Double?
    let pe: Double?
    let earningsAnnouncement: String?
    let sharesOutstanding: Double?
    let timestamp: Double?
    
    init(json: JSON) {
        symbol = json["symbol"].string
        name = json["name"].string
        price = json["price"].double
        changesPercentage = json["changesPercentage"].double
        change = json["change"].double
        dayLow = json["dayLow"].double
        dayHigh = json["dayHigh"].double
        yearHigh = json["yearHigh"].double
        yearLow = json["yearLow"].double
        marketCap = json["marketCap"].double
        priceAvg50 = json["priceAvg50"].double
        priceAvg200 = json["priceAvg200"].double
        volume = json["volume"].double
        avgVolume = json["avgVolume"].double
        exchange = json["exchange"].string
        open = json["open"].double
        previousClose = json["previousClose"].double
        eps = json["eps"].double
        pe = json["pe"].double
        earningsAnnouncement = json["earningsAnnouncement"].string
        sharesOutstanding = json["sharesOutstanding"].double
        timestamp = json["timestamp"].double
    }
    
}
