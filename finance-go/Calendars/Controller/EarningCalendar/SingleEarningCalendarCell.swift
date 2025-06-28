//
//  SingleEarningCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class SingleEarningCalendarCell: UITableViewCell {
    var earningCalendar: EarningCalendar? {
        didSet {
            guard let earningCalendar = earningCalendar else { return }

            companyNameLabel.attributedText = nil
            companySymbolLabel.attributedText = nil
            companySymbolLabel.text = earningCalendar.symbol
            let companyName = CompanyStore.shared.companyName(symbol: earningCalendar.symbol)
            companyNameLabel.text = companyName
            if companyName == "-" {
                companyNameLabel.textAlignment = .center
            } else {
                companyNameLabel.textAlignment = .left
            }
//            dateLabel.text = earningCalendar.date
            if let epsEstimated = earningCalendar.epsEstimated {
                if let company = CompanyStore.shared.item(symbol: earningCalendar.symbol) {
                    epsEstimatedLabel.text = convertDoubleToCurrency(amount: epsEstimated, localeIdentifier: company.localeIdentifier)
                } else {
                    epsEstimatedLabel.text = convertDoubleToCurrency(amount: epsEstimated)
                }
            } else {
                epsEstimatedLabel.text = "-"
            }
            if let eps = earningCalendar.eps {
                if let company = CompanyStore.shared.item(symbol: earningCalendar.symbol) {
                    epsLabel.text = convertDoubleToCurrency(amount: eps, localeIdentifier: company.localeIdentifier)
                } else {
                    epsLabel.text = convertDoubleToCurrency(amount: eps)
                }
            } else {
                epsLabel.text = "-"
            }
        }
    }

    var searchText: String = "" {
        didSet {
            if let symbol = earningCalendar?.symbol, let companyName = CompanyStore.shared.item(symbol: symbol)?.name {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: companyName)

                let range: NSRange = (companyName as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange1, range: range)

                companyNameLabel.attributedText = attrString
            }

            if let companyCode = earningCalendar?.symbol {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: companyCode)

                let range: NSRange = (companyCode as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

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

    lazy var epsEstimatedLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
    }

    lazy var epsLabel = UILabel().then { label in
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
        stackView.addArrangedSubview(epsEstimatedLabel)
        stackView.addArrangedSubview(epsLabel)

        companySymbolLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.48)
        }

        epsEstimatedLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }

        epsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
