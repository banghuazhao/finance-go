//
//  MenuCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class MenuCell: UITableViewCell {
    var menuItem: MenuItem? {
        didSet {
            guard let menuItem = menuItem else { return }
            iconView.image = menuItem.icon
            titleLabel.text = menuItem.title
        }
    }
    
    lazy var iconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
    }

    lazy var titleLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white
        label.font = FontExtension.normal
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
