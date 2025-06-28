//
//  StockGrade.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/27.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

let stockGradeDict = [
    "Strong Buy": 7,
    "Buy": 6,
    "Overweight": 5,
    "Outperform": 5,
    "Peer Perform": 4,
    "Market Perform": 4,
    "Sector Perform": 4,
    "Equal-Weight": 4,
    "Neutral": 4,
    "Hold": 4,
    "Underweight": 3,
    "Underperform": 3,
    "Sell": 2,
    "Strong Sell": 1,
]

class StockGrade {
    let symbol: String
    let date: String
    let gradingCompany: String
    let previousGrade: String
    let newGrade: String

    let upOrDown: String
    
    let color: UIColor

    init(dict: JSON) {
        symbol = dict["symbol"].stringValue
        date = dict["date"].stringValue
        gradingCompany = dict["gradingCompany"].stringValue
        previousGrade = dict["previousGrade"].stringValue
        newGrade = dict["newGrade"].stringValue
        
        if let previous = stockGradeDict[previousGrade],
           let new = stockGradeDict[newGrade] {
            if new > previous {
                upOrDown = "Upgrade".localized()
                color = UIColor.increaseNumberGreen
            } else if  new == previous {
                upOrDown = "Maintains".localized()
                color = UIColor.black
            } else {
                upOrDown = "Downgrade".localized()
                color = UIColor.decreaseNumberRed
            }
        } else if let _ = stockGradeDict[newGrade] {
            upOrDown = "Initiated".localized()
            color = UIColor.black
        } else {
            upOrDown = "-"
            color = UIColor.black
        }
    }
}
