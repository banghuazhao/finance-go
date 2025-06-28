//
//  UITableView+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/3.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

extension UITableView {
    func addTopBounceAreaView(color: UIColor = .white) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color
        view.tag = 100

        insertSubview(view, at: 0)
    }
}
