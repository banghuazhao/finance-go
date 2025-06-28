//
//  UIView+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/4.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
