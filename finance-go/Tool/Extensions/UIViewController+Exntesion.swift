//
//  UIViewController+Exntesion.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/1/13.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

extension UIViewController {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#9C5F8A").cgColor, UIColor(hex: "#282078").cgColor, UIColor(hex: "#3961E9").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0, 0.5, 1]

//        gradientLayer.colors = [UIColor.navBarColor.cgColor, UIColor.tabBarColor.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return (UIApplication.shared.statusBarFrame.size.height) +
            (navigationController?.navigationBar.frame.height ?? 0.0)
    }

    var topbarHeight2: CGFloat {
        let y = navigationController?.navigationBar.frame.origin.y ?? 0.0

        return (navigationController?.navigationBar.frame.height ?? 0.0) + y
    }

    var statusbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}
