//
//  HolderProfile.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 11/21/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class HolderProfile {
    let holderName: String
    let shares: Int
    let dateReported: String
    let change: Int
    
    init(dict: JSON) {
        holderName = dict["holder"].stringValue
        shares = dict["shares"].intValue
        dateReported = dict["dateReported"].stringValue
        change = dict["change"].intValue
    }
}
