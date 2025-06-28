//
//  EarningsCalendar.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/29/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Foundation
import SwiftyJSON

class EarningCalendar: FGCalendar {
    var date: String
    var symbol: String
    let eps: Double?
    let epsEstimated: Double?
    let time: String
    let revenue: Double?
    let revenueEstimated: Double?

    init(json: JSON) {
        date = json["date"].string ?? "No Data".localized()
        symbol = json["symbol"].string ?? "No Data".localized()
        eps = json["eps"].double
        epsEstimated = json["epsEstimated"].double
        time = json["time"].string ?? "No Data".localized()
        revenue = json["revenue"].double
        revenueEstimated = json["revenueEstimated"].double
    }
}

class EarningCalendarStore {
    static let shared = EarningCalendarStore()
    private(set) var items: [EarningCalendar] = []
    private(set) var companies: [Company] = []

    private init() {}

    func resetItems(earningCalendars: [EarningCalendar]) {
        items = earningCalendars
    }

    func items(atDate: Date?) -> [EarningCalendar] {
        guard let atDate = atDate else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return items.filter { earningCalendar in
            let dateString = formatter.string(from: atDate)
            return earningCalendar.date == dateString
        }
    }

    func append(item: EarningCalendar) {
        items.append(item)
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> EarningCalendar {
        return items[index]
    }

    func calendar(for company: Company) -> EarningCalendar {
        let index = companies.firstIndex(where: { $0.symbol == company.symbol })!
        return item(at: index)
    }
}
