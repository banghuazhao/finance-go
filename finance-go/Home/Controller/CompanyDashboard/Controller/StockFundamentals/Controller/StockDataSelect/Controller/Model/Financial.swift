//
//  Financial.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/3.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Financial {
    var symbol: String { get set }
    var date: String { get set  }
    var peroid: String { get set  }
    init(dict: JSON)
    func createStockDatas() -> [StockData]
}
