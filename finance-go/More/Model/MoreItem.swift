//
//  MoreItem.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 1/1/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

struct MoreItem {
    typealias didSelectCollectionViewAtIndexPathAction = (UICollectionView, IndexPath)->()
    var title: String
    let icon: UIImage?
    var action: didSelectCollectionViewAtIndexPathAction?
    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
    
    init(title: String, icon: UIImage?, action: didSelectCollectionViewAtIndexPathAction?) {
        self.title = title
        self.icon = icon
        self.action = action
    }
}
