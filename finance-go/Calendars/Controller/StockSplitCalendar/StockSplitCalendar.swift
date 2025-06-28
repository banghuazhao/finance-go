//
//  StockSplitCalendar.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/29/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Foundation
import SwiftyJSON

class StockSplitCalendar: FGCalendar {
    var date: String
    var symbol: String
    let numerator: Double?
    let denominator: Double?
    var stockSplitRatio: String = "-"

    init(json: JSON) {
        date = json["date"].string ?? "No Data".localized()
        symbol = json["symbol"].string ?? "No Data".localized()
        numerator = json["numerator"].double
        denominator = json["denominator"].double
        if let numerator = numerator, let denominator = denominator {
            stockSplitRatio = "\(convertDoubleToDecimal(amount: denominator)) - \(convertDoubleToDecimal(amount: numerator))"
        } else {
            stockSplitRatio = "-".localized()
        }
    }
}

class StockSplitCalendarStore {
    static let shared = StockSplitCalendarStore()
    private(set) var items: [StockSplitCalendar] = []
    private(set) var companies: [Company] = []

    private init() {}

    func resetItems(stockSplitCalendars: [StockSplitCalendar]) {
        items = stockSplitCalendars
    }

    func items(atDate: Date?) -> [StockSplitCalendar] {
        guard let atDate = atDate else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return items.filter { stockSplitCalendar in
            let dateString = formatter.string(from: atDate)
            return stockSplitCalendar.date == dateString
        }
    }

    func append(item: StockSplitCalendar) {
        items.append(item)
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> StockSplitCalendar {
        return items[index]
    }

    func calendar(for company: Company) -> StockSplitCalendar {
        let index = companies.firstIndex(where: { $0.symbol == company.symbol })!
        return item(at: index)
    }
}
