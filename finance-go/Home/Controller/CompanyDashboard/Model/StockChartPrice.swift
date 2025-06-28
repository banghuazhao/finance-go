//
//  StockChartPrice.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/16.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class StockChartPrice: Equatable {
    let date: String
    let openValue: Double
    let low: Double
    let high: Double
    let close: Double
    let volume: Int
    init(json: JSON) {
        date = json["date"].stringValue
        openValue = json["open"].doubleValue
        low = json["low"].doubleValue
        high = json["high"].doubleValue
        close = json["close"].doubleValue
        volume = json["volume"].intValue
    }

    init(jsonDaily: JSON) {
        date = jsonDaily["date"].stringValue
        openValue = 0
        low = 0
        high = 0
        close = jsonDaily["close"].doubleValue
        volume = 0
    }

    static func == (lhs: StockChartPrice, rhs: StockChartPrice) -> Bool {
        return lhs.date == rhs.date && lhs.openValue == rhs.openValue && lhs.close == rhs.close && lhs.volume == rhs.volume
    }
}
