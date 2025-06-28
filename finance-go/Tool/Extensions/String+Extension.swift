//
//  String+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/2.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func indexOfSubstring(subString: String) -> Int? {
        if let range: Range<String.Index> = self.range(of: subString) {
            let index: Int = distance(from: startIndex, to: range.lowerBound)
            return index
        } else {
            // substring not found
            return nil
        }
    }

    func contains(word: String) -> Bool {
        return range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}
