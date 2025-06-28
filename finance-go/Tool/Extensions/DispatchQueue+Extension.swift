//
//  DispatchQueue+Extension.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static func background(qos: DispatchQoS.QoSClass = .userInitiated, background: (()->Void)?, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: qos).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

}
