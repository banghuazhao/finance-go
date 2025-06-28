//
//  StockDataSelect.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class StockDataSelect {
    typealias didSelectAction = () -> Void
    
    let name: String
    let image: UIImage?
    let action: didSelectAction?
   

    init(name: String, image: UIImage?, action: didSelectAction?) {
        self.name = name
        self.image = image
        self.action = action
    }
}
