//
//  Date+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/6.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension Date {
    var dateFormatStringDetail: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    var stringTimeHHmm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    var stringDayTimeMMddHHmm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    var stringDayyyyyMMdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    var stringDay_yyyy_MM_dd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    static func convertStringyyyyMMddToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }

    static func convertStringyyyyMMddHHmmssToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }

//    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
//        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
//        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
//        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
//        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
//        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
//
//        return (month: month, day: day, hour: hour, minute: minute, second: second)
//    }

    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
