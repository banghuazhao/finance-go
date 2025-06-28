//
//  IPOCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class IPOCalendarCell: UITableViewCell {
    var iPOCalendar: IPOCalendar? {
        didSet {
            guard let iPOCalendar = iPOCalendar else { return }
            companyValueLabel.text = iPOCalendar.symbol
            dateValueLabel.text = iPOCalendar.date
            exchangeValueLabel.text = iPOCalendar.exchange
            actionsValueLabel.text = iPOCalendar.actions

            if let shares = iPOCalendar.shares {
                sharesValueLabel.text = "\(shares)"
            } else {
                sharesValueLabel.text = "-"
            }

            priceRangeValueLabel.text = iPOCalendar.priceRange

            if let marketCap = iPOCalendar.marketCap {
                marketCapValueLabel.text = convertDoubleToCurrency(amount: marketCap, companySymbol: iPOCalendar.symbol)
            } else {
                marketCapValueLabel.text = "-"
            }
        }
    }

    lazy var cellView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Company Symbol".localized()
    }

    lazy var companyValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var dateNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Date".localized()
    }

    lazy var dateValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var exchangeNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Exchange".localized()
    }

    lazy var exchangeValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var actionsNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Actions"
    }

    lazy var actionsValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var sharesNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Shares".localized()
    }

    lazy var sharesValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var priceRangeNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Price Range".localized()
    }

    lazy var priceRangeValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var marketCapNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Market Cap".localized()
    }

    lazy var marketCapValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        cellView.layer.shadowColor = UIColor.black1.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 1

        cellView.addSubview(companyNameLabel)
        cellView.addSubview(companyValueLabel)

        cellView.addSubview(dateNameLabel)
        cellView.addSubview(dateValueLabel)

        cellView.addSubview(exchangeNameLabel)
        cellView.addSubview(exchangeValueLabel)

        cellView.addSubview(actionsNameLabel)
        cellView.addSubview(actionsValueLabel)

        cellView.addSubview(sharesNameLabel)
        cellView.addSubview(sharesValueLabel)

        cellView.addSubview(priceRangeNameLabel)
        cellView.addSubview(priceRangeValueLabel)

        cellView.addSubview(marketCapNameLabel)
        cellView.addSubview(marketCapValueLabel)

        let containerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        companyNameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(containerInset)
        }
        companyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        dateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        dateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        exchangeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        exchangeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(exchangeNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        actionsNameLabel.snp.makeConstraints { make in
            make.top.equalTo(exchangeValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        actionsValueLabel.snp.makeConstraints { make in
            make.top.equalTo(actionsNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        sharesNameLabel.snp.makeConstraints { make in
            make.top.equalTo(actionsValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        sharesValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sharesNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        priceRangeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(sharesValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        priceRangeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(priceRangeNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        marketCapNameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceRangeValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        marketCapValueLabel.snp.makeConstraints { make in
            make.top.equalTo(marketCapNameLabel.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview().inset(containerInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
