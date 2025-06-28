//
//  HistoricalDividendCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class HistoricalStockSplitCalendarCell: UITableViewCell {
    var stockSplitCalendar: StockSplitCalendar? {
        didSet {
            guard let stockSplitCalendar = stockSplitCalendar else { return }

            label1.text = stockSplitCalendar.date

            if let numerator = stockSplitCalendar.numerator {
                label2.text = convertDoubleToDecimal(amount: numerator)
            } else {
                label2.text = "-"
            }

            if let denominator = stockSplitCalendar.denominator {
                label3.text = convertDoubleToDecimal(amount: denominator)
            } else {
                label3.text = "-"
            }

            label4.text = stockSplitCalendar.stockSplitRatio
        }
    }

    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 4
    }

    lazy var label1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
    }

    lazy var label2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
    }

    lazy var label3 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
    }

    lazy var label4 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        stackView.addArrangedSubview(label4)

        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        label2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        label3.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        label4.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
