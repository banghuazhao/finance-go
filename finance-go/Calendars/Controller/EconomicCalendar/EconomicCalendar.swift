//
//  EconomicCalendar.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/29/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Foundation
import SwiftyJSON

struct EconomicCalendar: FGCalendar {
    var date: String
    var symbol: String
    var region: String
    let event: String
    let actual: Double?
    let previous: Double?
    let change: Double?
    let changePercentage: Double?

    init(json: JSON) {
        date = json["date"].string ?? "-"
        symbol = json["country"].string ?? "-"
        region = json["country"].string ?? "-"
        event = json["event"].string ?? "-"
        actual = json["actual"].double
        previous = json["previous"].double
        change = json["change"].double
        changePercentage = json["changePercentage"].double
    }
}

class EconomicCalendarStore {
    static let shared = EconomicCalendarStore()
    private(set) var items: [EconomicCalendar] = []

    private init() {}

    func resetItems(calendars: [EconomicCalendar]) {
        items = calendars
    }

    func items(atDate: Date?) -> [EconomicCalendar] {
        guard let atDate = atDate else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: atDate)
        return items.filter { calendar in
            if let calendarDate = Date.convertStringyyyyMMddHHmmssToDate(string: calendar.date) {
                let calendarDateString = formatter.string(from: calendarDate)
                return calendarDateString == dateString
            } else {
                return false
            }
        }
    }

    func append(item: EconomicCalendar) {
        items.append(item)
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> EconomicCalendar {
        return items[index]
    }
}
