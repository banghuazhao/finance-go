//
//  Collection+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/4.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
