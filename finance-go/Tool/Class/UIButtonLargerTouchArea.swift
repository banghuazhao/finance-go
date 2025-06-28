//
//  UIButtonLargerTouchArea.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class UIButtonLargerTouchArea: UIButton {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 16
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }

}
