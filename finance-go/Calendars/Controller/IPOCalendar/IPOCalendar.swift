//
//  IPOCalendar.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/29/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Cache
import Foundation
import SwiftyJSON

class IPOCalendar: FGCalendar {
    var date: String
    var symbol: String
    let exchange: String
    let actions: String
    let shares: Int?
    let priceRange: String
    let marketCap: Double?
    
    init(json: JSON) {
        self.date = json["date"].string ?? "No Data".localized()
        self.symbol = json["symbol"].string ?? "No Data".localized()
        self.exchange = json["exchange"].string ?? "No Data".localized()
        self.actions = json["actions"].string ?? "No Data".localized()
        self.shares = json["shares"].int
        self.priceRange = json["priceRange"].string ?? "-"
        self.marketCap = json["marketCap"].double
    }
}

class IPOCalendarStore {
    static let shared = IPOCalendarStore()
    private(set) var items: [IPOCalendar] = []
    private(set) var companies: [Company] = []

    var storage: Storage<String, Data>? {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(name: "IPOCalendar", expiry: .date(Date().addingTimeInterval(8 * 60 * 60)), directory: Constants.cacheDirectory),
            memoryConfig: MemoryConfig(),
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }

    private init() {}
    
    func resetItems(ipoCalendars: [IPOCalendar]) {
        items = ipoCalendars
    }
    
    func items(atDate: Date?) -> [IPOCalendar] {
        guard let atDate = atDate else { return [] }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return items.filter { ipoCalendar in
            let dateString = formatter.string(from: atDate)
            return ipoCalendar.date == dateString
        }
    }

    func append(item: IPOCalendar) {
        items.append(item)
    }

    var count: Int {
        return items.count
    }

    func item(at index: Int) -> IPOCalendar {
        return items[index]
    }

    func calendar(for company: Company) -> IPOCalendar {
        let index = companies.firstIndex(where: { $0.symbol == company.symbol })!
        return item(at: index)
    }
}
