//
//  StockNew.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 9/14/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class StockNew {
    let site: String
    let title: String
    let text: String
    let symbol: String
    let imageURL: String
    let url: String
    let date: String
    
    init(json: JSON) {
        self.site = json["site"].string ?? "No Data".localized()
        self.title = json["title"].string ?? "No Data".localized()
        self.text = json["text"].string ?? "No Data".localized()
        self.symbol = json["symbol"].string ?? "No Data".localized()
        self.imageURL = json["image"].string ?? "No Data".localized()
        self.url = json["url"].string ?? "No Data".localized()
        self.date = json["publishedDate"].string ?? "No Data".localized()
    }
}
