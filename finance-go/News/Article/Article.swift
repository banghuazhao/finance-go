//
//  Article.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class Article {
    let title: String
    let date: String
    let content: String
    let tickers: String
    let image: String
    let link: String

    init(json: JSON) {
        title = json["title"].string ?? "No Data".localized()
        date = json["date"].string ?? "No Data".localized()
        content = json["content"].string ?? "No Data".localized()
        tickers = json["tickers"].string ?? "No Data".localized()
        image = json["image"].string ?? "No Data".localized()
        link = json["link"].string ?? "No Data".localized()
    }
}
