//
//  EconomicCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class EconomicCalendarCell: UITableViewCell {
    var economicCalendar: EconomicCalendar? {
        didSet {
            guard let economicCalendar = economicCalendar else { return }

            companyValueLabel.text = economicCalendar.region

            dateValueLabel.text = economicCalendar.date

            recordDateValueLabel.text = economicCalendar.event

            if let actual = economicCalendar.actual, let change = economicCalendar.change, let changePercent = economicCalendar.changePercentage {
                let attributedString = NSMutableAttributedString()

                attributedString.append(NSAttributedString(
                    string: convertDoubleToDecimal(amount: actual),
                    attributes: [NSAttributedString.Key.font: UIFont.title,
                                 NSAttributedString.Key.foregroundColor: UIColor.black1]))

                let changesString = change >= 0 ? "+" + convertDoubleToDecimal(amount: change) : convertDoubleToDecimal(amount: change)
                let changePercentString = change >= 0 ? "(↑" + convertDoubleToDecimal(amount: changePercent) + "%)" : "(↓" + convertDoubleToDecimal(amount: fabs(changePercent)) + "%)"
                let changesStringAll = changesString + " " + changePercentString

                attributedString.append(NSAttributedString(
                    string: "  " + changesStringAll,
                    attributes: [NSAttributedString.Key.font: UIFont.title,
                                 NSAttributedString.Key.foregroundColor: change >= 0 ? UIColor.increaseNumberGreen : UIColor.decreaseNumberRed]))

                paymentDateValueLabel.attributedText = attributedString
            } else {
                paymentDateValueLabel.attributedText = NSAttributedString(attributedString: NSAttributedString(
                    string: "-",
                    attributes: [NSAttributedString.Key.font: UIFont.title,
                                 NSAttributedString.Key.foregroundColor: UIColor.black1]))
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
        label.text = "Region".localized()
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

    lazy var recordDateNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Event".localized()
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
        label.text = "Value".localized()
    }

    lazy var paymentDateValueLabel = UILabel().then { label in
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

        cellView.addSubview(recordDateNameLabel)
        cellView.addSubview(recordDateValueLabel)

        cellView.addSubview(paymentDateNameLabel)
        cellView.addSubview(paymentDateValueLabel)

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

        recordDateNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel.snp.bottom).offset(16)
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
            make.bottom.left.right.equalToSuperview().inset(containerInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
