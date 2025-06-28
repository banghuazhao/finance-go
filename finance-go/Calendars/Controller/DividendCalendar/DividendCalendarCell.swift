//
//  DividendCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class DividendCalendarCell: UITableViewCell {
    var dividendCalendar: DividendCalendar? {
        didSet {
            guard let dividendCalendar = dividendCalendar else { return }

            companyValueLabel.text = dividendCalendar.symbol

            dateValueLabel.text = dividendCalendar.date

            if let dividend = dividendCalendar.dividend {
                value1.text = convertDoubleToCurrency(amount: dividend, companySymbol: dividendCalendar.symbol)
            } else {
                value1.text = "-".localized()
            }

            if let adjDividend = dividendCalendar.adjDividend {
                value2.text = convertDoubleToCurrency(amount: adjDividend, companySymbol: dividendCalendar.symbol)
            } else {
                value2.text = "-"
            }

            if let recordDate = dividendCalendar.recordDate, recordDate != "" {
                recordDateValueLabel.text = recordDate
            } else {
                recordDateValueLabel.text = "-"
            }

            if let paymentDate = dividendCalendar.paymentDate, paymentDate != "" {
                paymentDateValueLabel.text = paymentDate
            } else {
                paymentDateValueLabel.text = "-"
            }

            if let declarationDate = dividendCalendar.declarationDate, declarationDate != "" {
                declarationDateValueLabel.text = declarationDate
            } else {
                declarationDateValueLabel.text = "-"
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

    lazy var stackView1 = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 4
    }

    lazy var stackView2 = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 4
    }

    lazy var label1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Dividend".localized()
        label.textAlignment = .left
    }

    lazy var label2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Adjust Dividend".localized()
        label.textAlignment = .left
    }

    lazy var value1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.title
        label.textAlignment = .left
    }

    lazy var value2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.title
        label.textAlignment = .left
    }

    lazy var recordDateNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Record Date".localized()
    }

    lazy var recordDateValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var paymentDateNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Payment Date".localized()
    }

    lazy var paymentDateValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var declarationDateNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Declaration Date".localized()
    }

    lazy var declarationDateValueLabel = UILabel().then { label in
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

        cellView.addSubview(stackView1)
        cellView.addSubview(stackView2)

        cellView.addSubview(label1)
        cellView.addSubview(label2)
        cellView.addSubview(value1)
        cellView.addSubview(value2)

        cellView.addSubview(recordDateNameLabel)
        cellView.addSubview(recordDateValueLabel)

        cellView.addSubview(paymentDateNameLabel)
        cellView.addSubview(paymentDateValueLabel)

        cellView.addSubview(declarationDateNameLabel)
        cellView.addSubview(declarationDateValueLabel)

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

        stackView1.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        stackView1.addArrangedSubview(label1)
        stackView1.addArrangedSubview(label2)

        stackView2.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        stackView2.addArrangedSubview(value1)
        stackView2.addArrangedSubview(value2)

        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.45)
        }

        label2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.45)
        }

        value1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.45)
        }

        value2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.45)
        }

        recordDateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        recordDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(recordDateNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        paymentDateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(recordDateValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        paymentDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentDateNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        declarationDateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentDateValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        declarationDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(declarationDateNameLabel.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview().inset(containerInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
