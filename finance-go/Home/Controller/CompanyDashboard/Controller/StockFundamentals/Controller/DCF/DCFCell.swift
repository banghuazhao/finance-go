//
//  DCFCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/26.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class DCFCell: UITableViewCell {
    var company: Company?

    var dcf: DCF? {
        didSet {
            guard let dcf = dcf, let company = company else { return }

            dateLabel.text = Date.convertStringyyyyMMddToDate(string: dcf.date)?.stringDayyyyyMMdd
            if let stockPrice = dcf.stockPrice {
                stockPriceLabel.text = stockPrice.convertToCurrency(localeIdentifier: company.localeIdentifier)
            } else {
                stockPriceLabel.text = "-"
            }

            if let dcfValue = dcf.dcf {
                dcfLabel.text = dcfValue.convertToCurrency(localeIdentifier: company.localeIdentifier)
            } else {
                dcfLabel.text = "-"
            }
        }
    }

    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 8
    }

    lazy var dateLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
    }

    lazy var stockPriceLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
    }

    lazy var dcfLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
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
