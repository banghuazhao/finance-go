//
//  MoreHeaderView.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class MoreHeaderView: UICollectionReusableView {
    lazy var titleLabel = UILabel().then { label in
        label.textColor = .white
        label.font = .bigTitle
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
