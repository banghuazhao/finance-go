//
//  EarningCallTranscriptDate.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/31.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class EarningCallTranscriptDate {
    let quarter: Int
    let year: Int
    let time: String
    init(list: JSON) {
        quarter = list[0].intValue
        year = list[1].intValue
        time = list[2].stringValue
    }
}
