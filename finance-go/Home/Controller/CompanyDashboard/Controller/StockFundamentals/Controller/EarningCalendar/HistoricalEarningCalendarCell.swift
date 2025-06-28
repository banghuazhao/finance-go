//
//  HistoricalEarningCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class HistoricalEarningCalendarCell: UITableViewCell {
    var earningCalendar: EarningCalendar? {
        didSet {
            guard let earningCalendar = earningCalendar else { return }

            label1.text = earningCalendar.date

            if let epsEstimated = earningCalendar.epsEstimated {
                if let company = CompanyStore.shared.item(symbol: earningCalendar.symbol) {
                    label2.text = convertDoubleToCurrency(amount: epsEstimated, localeIdentifier: company.localeIdentifier)
                } else {
                    label2.text = convertDoubleToCurrency(amount: epsEstimated)
                }
            } else {
                label2.text = "-"
            }
            if let eps = earningCalendar.eps {
                if let company = CompanyStore.shared.item(symbol: earningCalendar.symbol) {
                    label3.text = convertDoubleToCurrency(amount: eps, localeIdentifier: company.localeIdentifier)
                } else {
                    label3.text = convertDoubleToCurrency(amount: eps)
                }
            } else {
                label3.text = "-"
            }

            if let epsEstimated = earningCalendar.epsEstimated, let eps = earningCalendar.eps, epsEstimated != 0 {
                let change = (eps - epsEstimated) / fabs(epsEstimated) * 100
                label4.text = (change > 0 ? "+" : "") + String(format: "%.2f%%", change)
                label4.textColor = UIColor.white1
                if change > 0 {
                    label4.textColor = UIColor.increaseGreen
                } else if change < 0 {
                    label4.textColor = UIColor.decreaseRed
                }
            } else {
                label4.text = "-"
            }
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
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        label2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        label3.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        label4.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
