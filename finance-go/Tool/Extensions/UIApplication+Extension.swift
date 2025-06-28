//
//  UIApplication+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/2/15.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIApplication {
    class func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
}
