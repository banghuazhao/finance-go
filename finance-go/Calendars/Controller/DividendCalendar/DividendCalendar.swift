//
//  DividendCalendar.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/29/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Foundation
import SwiftyJSON

struct DividendCalendar: FGCalendar {
    var date: String
    var symbol: String
    let adjDividend: Double?
    let dividend: Double?
    let recordDate: String?
    let paymentDate: String?
    let declarationDate: String?

    init(json: JSON) {
        date = json["date"].string ?? "No Data".localized()
        symbol = json["symbol"].string ?? "No Data".localized()
        adjDividend = json["adjDividend"].double
        dividend = json["dividend"].double
        recordDate = json["recordDate"].string ?? "No Data".localized()
        paymentDate = json["paymentDate"].string ?? "No Data".localized()
        declarationDate = json["declarationDate"].string ?? "No Data".localized()
    }
}

class DividendCalendarStore {
    static let shared = DividendCalendarStore()
    private(set) var items: [DividendCalendar] = []
    private(set) var companies: [Company] = []

    private init() {}

    func resetItems(dividendCalendars: [DividendCalendar]) {
        items = dividendCalendars
    }

    func items(atDate: Date?) -> [DividendCalendar] {
        guard let atDate = atDate else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return items.filter { dividendCalendar in
            let dateString = formatter.string(from: atDate)
            return dividendCalendar.date == dateString
        }
    }

    func append(item: DividendCalendar) {
        items.append(item)
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> DividendCalendar {
        return items[index]
    }

    func calendar(for company: Company) -> DividendCalendar {
        let index = companies.firstIndex(where: { $0.symbol == company.symbol })!
        return item(at: index)
    }
}
