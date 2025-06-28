//
//  SingleEconomicCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class SingleEconomicCalendarCell: UITableViewCell {
    var economicCalendar: EconomicCalendar? {
        didSet {
            guard let economicCalendar = economicCalendar else { return }

            companyNameLabel.attributedText = nil
            companySymbolLabel.attributedText = nil
            companySymbolLabel.text = economicCalendar.region
            companyNameLabel.text = economicCalendar.event
            if economicCalendar.event == "-" {
                companyNameLabel.textAlignment = .center
            } else {
                companyNameLabel.textAlignment = .left
            }
            if let actual = economicCalendar.actual {
                dividendLabel.text = convertDoubleToDecimal(amount: actual)
            } else {
                dividendLabel.text = "-"
            }
        }
    }

    var searchText: String = "" {
        didSet {
            if let event = economicCalendar?.event {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: event)

                let range: NSRange = (event as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange1, range: range)

                companyNameLabel.attributedText = attrString
            }

            if let region = economicCalendar?.region {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: region)

                let range: NSRange = (region as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange2, range: range)

                companySymbolLabel.attributedText = attrString
            }
        }
    }

    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 4
    }

    lazy var companySymbolLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
    }

    lazy var dividendLabel = UILabel().then { label in
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

        stackView.addArrangedSubview(companySymbolLabel)
        stackView.addArrangedSubview(companyNameLabel)
        stackView.addArrangedSubview(dividendLabel)

        companySymbolLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.55)
        }

        dividendLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
