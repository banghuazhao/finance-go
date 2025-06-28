//
//  MoreAppsRemoveAdsCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/2/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class MoreAppsRemoveAdsCell: UITableViewCell {
    lazy var label = UILabel().then { label in
        label.text = "Remove this Ads forever".localized()
        label.font = UIFont.title
        label.numberOfLines = 0
        label.textColor = .white
    }

    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        tintColor = .clear
        selectionStyle = .none

        contentView.addSubview(label)
        contentView.addSubview(rightArrowImageView)

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(rightArrowImageView).offset(-20)
            make.bottom.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }

        rightArrowImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
