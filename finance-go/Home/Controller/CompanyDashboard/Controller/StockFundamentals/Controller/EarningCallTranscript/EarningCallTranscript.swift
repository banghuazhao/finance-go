//
//  EarningCallTranscript.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/6.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class EarningCallTranscript {
    let symbol: String
    let quarter: Int
    let year: Int
    let date: String
    let content: String
    
    init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        quarter = dict["quarter"].intValue
        year = dict["year"].intValue
        date = dict["date"].stringValue
        content = dict["content"].stringValue
    }
}
