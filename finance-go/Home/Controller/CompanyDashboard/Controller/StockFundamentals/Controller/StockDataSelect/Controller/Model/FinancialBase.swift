//
//  FinancialBase.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

class FinancialBase {
    let name: String
    let endPoint: String
    let financial: Financial.Type
    init(name: String, endPoint: String, financial: Financial.Type) {
        self.name = name
        self.endPoint = endPoint
        self.financial = financial
    }
}
