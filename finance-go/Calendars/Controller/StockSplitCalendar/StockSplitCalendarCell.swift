//
//  StockSplitCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class StockSplitCalendarCell: UITableViewCell {
    var stockSplitCalendar: StockSplitCalendar? {
        didSet {
            guard let stockSplitCalendar = stockSplitCalendar else { return }
            companyValueLabel.text = stockSplitCalendar.symbol
            dateValueLabel.text = stockSplitCalendar.date

            if let numerator = stockSplitCalendar.numerator {
                numeratorValueLabel.text = convertDoubleToDecimal(amount: numerator)
            } else {
                numeratorValueLabel.text = "-"
            }

            if let denominator = stockSplitCalendar.denominator {
                denominatorValueLabel.text = convertDoubleToDecimal(amount: denominator)
            } else {
                denominatorValueLabel.text = "-"
            }

            
            stockSplitRatioValueLabel.text = stockSplitCalendar.stockSplitRatio
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

    lazy var numeratorNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Numerator".localized()
    }

    lazy var numeratorValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var denominatorNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Denominator".localized()
    }

    lazy var denominatorValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var stockSplitRatioNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Stock Split Ratio".localized()
    }

    lazy var stockSplitRatioValueLabel = UILabel().then { label in
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

        cellView.addSubview(numeratorNameLabel)
        cellView.addSubview(numeratorValueLabel)

        cellView.addSubview(denominatorNameLabel)
        cellView.addSubview(denominatorValueLabel)

        cellView.addSubview(stockSplitRatioNameLabel)
        cellView.addSubview(stockSplitRatioValueLabel)

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

        numeratorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        numeratorValueLabel.snp.makeConstraints { make in
            make.top.equalTo(numeratorNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        denominatorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(numeratorValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        denominatorValueLabel.snp.makeConstraints { make in
            make.top.equalTo(denominatorNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        stockSplitRatioNameLabel.snp.makeConstraints { make in
            make.top.equalTo(denominatorValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        stockSplitRatioValueLabel.snp.makeConstraints { make in
            make.top.equalTo(stockSplitRatioNameLabel.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview().inset(containerInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
