//
//  DCFTitleCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/26.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class DCFTitleCell: UITableViewCell {

    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 8
    }

    lazy var dateLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.text = "Date".localized()
    }

    lazy var stockPriceLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "Stock Price".localized()
    }

    lazy var dcfLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "DCF"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(stockPriceLabel)
        stackView.addArrangedSubview(dcfLabel)

        dateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        stockPriceLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        dcfLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
