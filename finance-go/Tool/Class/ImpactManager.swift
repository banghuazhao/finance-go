//
//  ImpactManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/15.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class ImpactManager {
    
    static let shared = ImpactManager()
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    func generate(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        generator.impactOccurred()
    }
}
