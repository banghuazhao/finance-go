//
//  Double+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension Double {
    public var decimalString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        let number = NSNumber(value: self)
        let decimal = numberFormatter.string(from: number) ?? ""
        return decimal
    }

    public var decimalTwoDigitsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let number = NSNumber(value: self)
        let decimal = numberFormatter.string(from: number) ?? ""
        return decimal
    }

    public var decimalOneDigitsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        let number = NSNumber(value: self)
        let decimal = numberFormatter.string(from: number) ?? ""
        return decimal
    }

    func convertToCurrency(localeIdentifier: String = "en_US") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        numberFormatter.numberStyle = .currency
        numberFormatter.negativePrefix = numberFormatter.minusSign + numberFormatter.currencySymbol
        numberFormatter.minimumFractionDigits = 2
        if fabs(self) >= 10 {
            numberFormatter.maximumFractionDigits = 2
        } else if fabs(self) > 1 {
            numberFormatter.maximumFractionDigits = 4
        } else {
            numberFormatter.maximumFractionDigits = 6
        }
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }

    func convertToVariableDigitsDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        if fabs(self) >= 10 {
            numberFormatter.maximumFractionDigits = 2
        } else if fabs(self) > 1 {
            numberFormatter.maximumFractionDigits = 4
        } else {
            numberFormatter.maximumFractionDigits = 6
        }
        let number = NSNumber(value: self)
        let decimal = numberFormatter.string(from: number) ?? ""
        return decimal
    }

    func formatDecimalUsingAbbrevation() -> String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "K"),
            (100000.0, 1000000.0, "M"),
            (100000000.0, 1000000000.0, "B"),
            (100000000000.0, 1000000000000.0, "T"),
            (100000000000000.0, 1000000000000000.0, "P"),
            (100000000000000000.0, 1000000000000000000.0, "E"),
        ]
        // you can add more !

        let startValue = Double(abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value: value))!
    }

    func formatCurrencyUsingAbbrevation(localeIdentifier: String = "en_US") -> String {
        let numFormatter = NumberFormatter()
        numFormatter.locale = Locale(identifier: localeIdentifier)
        numFormatter.numberStyle = .currency
        numFormatter.negativePrefix = numFormatter.minusSign + numFormatter.currencySymbol

        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [
            (0, 1, ""),
            (1000.0, 1000.0, "K"),
            (100000.0, 1000000.0, "M"),
            (100000000.0, 1000000000.0, "B"),
            (100000000000.0, 1000000000000.0, "T"),
            (100000000000000.0, 1000000000000000.0, "P"),
            (100000000000000000.0, 1000000000000000000.0, "E"),
        ]
        // you can add more !

        let startValue = Double(abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor
        numFormatter.allowsFloats = true
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value: value))!
    }
}
