//
//  Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 11/21/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit



extension UILabel {
    func calculateMaxLines() -> Int {
        layoutIfNeeded()

        let myText = text! as NSString
        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)

        #if !targetEnvironment(macCatalyst)
            let lines = Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
        #else
            let lines = Int(ceil(CGFloat(labelSize.height) / font.lineHeight)) - 1
        #endif
        return lines
    }
}
