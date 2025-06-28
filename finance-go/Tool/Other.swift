//
//  Other.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 7/5/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

func convertDoubleToDecimal(amount: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: NSNumber(value: amount))!
}

func convertDoubleToCurrency(amount: Double, localeIdentifier: String = "en_US") -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: localeIdentifier)
    numberFormatter.numberStyle = .currency
    numberFormatter.negativePrefix = numberFormatter.minusSign + numberFormatter.currencySymbol
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: NSNumber(value: amount))!
}

func convertDoubleToCurrency(amount: Double, companySymbol: String) -> String {
    let numberFormatter = NumberFormatter()
    if let company = CompanyStore.shared.item(symbol: companySymbol) {
        numberFormatter.locale = Locale(identifier: company.localeIdentifier)
    } else {
        numberFormatter.locale = Locale(identifier: "en_US")
    }
    numberFormatter.numberStyle = .currency
    numberFormatter.negativePrefix = numberFormatter.minusSign + numberFormatter.currencySymbol
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: NSNumber(value: amount))!
}

#if !targetEnvironment(macCatalyst)
    func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }
#endif

func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

// func compareContain(s1: String , s2: String, searchText: String) -> Bool {
//    let s1IsContain = s1.contains(searchText)
//    let s2IsContain = s2.contains(searchText)
//    switch (s1IsContain, s2IsContain) {
//    case (true, false):
//        return true
//    case (false, true):
//        return false
//    case (true, true):
//        return s1 < s2
//    case (false, false):
//        return s1 < s2
//    }
// }

func compareFirstLetter(s1: String, s2: String) -> Bool {
    let s1IsNumber = s1.first?.isNumber ?? false
    let s2IsNumber = s2.first?.isNumber ?? false
    switch (s1IsNumber, s2IsNumber) {
    case (true, false):
        return false
    case (false, true):
        return true
    case (true, true):
        return s1 < s2
    case (false, false):
        return s1 < s2
    }
}

func createParagraphStyle(lineSpacing: CGFloat = 8) -> NSMutableParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    return paragraphStyle
}
