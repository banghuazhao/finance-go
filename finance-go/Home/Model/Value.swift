//
//  Value.swift
//  Financial Statements Go
//
//  Created by Lulin Y on 2021/11/5.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

enum ValueType: String {
    case all = "All"
    case stock = "Stock"
    case fund = "Fund"
    case etf = "ETF"
    case index = "Index"
    case cryptocurrency = "Cryptocurrency"
    case future = "Future"
    case forex = "Forex"
}

protocol Value {
    var name: String { get }
    var symbol: String { get }
    var type: ValueType { get }
    var price: Double? { get set }
    var changesPercentage: Double? { get set }
    var isWatched: Bool { get }
}
