//
//  TwoColumnTitleValue.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/19.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

class TwoColumnTitleValue {
    let title1: String
    let value1: String
    var isLink1: Bool = false
    let title2: String
    let value2: String
    var isLink2: Bool = false
    init(title1: String, value1: String, title2: String, value2: String, isLink1: Bool = false , isLink2: Bool = false) {
        self.title1 = title1
        self.value1 = value1
        self.title2 = title2
        self.value2 = value2
        self.isLink1 = isLink1
        self.isLink2 = isLink2
    }
}
