//
//  DCF.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/26.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class DCF {
    let symbol: String
    let date: String
    let dcf: Double?
    let stockPrice: Double?

    init(dictRealyTime: JSON) {
        symbol = dictRealyTime["symbol"].stringValue
        date = dictRealyTime["date"].string ?? "-"
        dcf = dictRealyTime["dcf"].double
        stockPrice = dictRealyTime["Stock Price"].double
    }
    
    init(dictStatement: JSON) {
        symbol = dictStatement["symbol"].stringValue
        date = dictStatement["date"].string ?? "-"
        dcf = dictStatement["dcf"].double
        stockPrice = dictStatement["price"].double
    }
}
