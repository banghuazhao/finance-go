//
//  Menu.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class CompanyDashboardItem {
    var title: String
    let icon: UIImage?
    var action: (() -> Void)?
    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
    init(title: String, icon: UIImage?, action: (() -> Void)?) {
        self.title = title
        self.icon = icon
        self.action = action
    }
}
