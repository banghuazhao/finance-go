//
//  CompanyProfile.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/20.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompanyProfile {
    let symbol : String
    let companyName : String
    let ceo : String
    let ipoDate : String
    let fullTimeEmployees : String
    let exchange : String
    let sector : String
    let industry : String
    let address : String
    let city : String
    let state : String
    let zip : String
    let country : String
    let website : String
    let description : String
    
    init(json: JSON) {
        self.symbol = json["symbol"].string ?? "-"
        self.companyName = json["companyName"].string ?? "-"
        self.ceo = json["ceo"].string ?? "-"
        self.ipoDate = json["ipoDate"].string ?? "-"
        self.fullTimeEmployees = json["fullTimeEmployees"].string ?? "-"
        self.exchange = json["exchange"].string ?? "-"
        self.sector = json["sector"].string ?? "-"
        self.industry = json["industry"].string ?? "-"
        self.address = json["address"].string ?? "-"
        self.city = json["city"].string ?? "-"
        self.state = json["state"].string ?? "-"
        self.zip = json["zip"].string ?? "-"
        self.country = json["country"].string ?? "-"
        self.website = json["website"].string ?? "-"
        self.description = json["description"].string ?? ""   
    }
}
