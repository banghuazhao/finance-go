//
//  EarningCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 12/30/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class EarningCalendarCell: UITableViewCell {
    var earningCalendar: EarningCalendar? {
        didSet {
            guard let earningCalendar = earningCalendar else { return }

            companyValueLabel.text = earningCalendar.symbol

            var time = ""

            if earningCalendar.time == "bmo" {
                time = "(" + "Before Market Open".localized() + ")"
            } else if earningCalendar.time == "amc" {
                time = "(" + "After Market Close".localized() + ")"
            }

            dateValueLabel.text = earningCalendar.date + " " + time

            if let epsEstimated = earningCalendar.epsEstimated {
                value1.text = convertDoubleToCurrency(amount: epsEstimated, companySymbol: earningCalendar.symbol)
            } else {
                value1.text = "-"
            }

            if let eps = earningCalendar.eps {
                value2.text = convertDoubleToCurrency(amount: eps, companySymbol: earningCalendar.symbol)
            } else {
                value2.text = "-"
            }

            if let epsEstimated = earningCalendar.epsEstimated, let eps = earningCalendar.eps, epsEstimated != 0 {
                let change = (eps - epsEstimated) / fabs(epsEstimated) * 100
                value3.text = (change > 0 ? "+" : "") + String(format: "%.2f%%", change)
                value3.textColor = UIColor.white1
                if change > 0 {
                    value3.textColor = UIColor.increaseNumberGreen
                } else if change < 0 {
                    value3.textColor = UIColor.decreaseNumberRed
                }
            } else {
                value3.text = "-"
            }

            if let revenue = earningCalendar.revenue, revenue != 0 {
                revenueValueLabel.text = convertDoubleToCurrency(amount: revenue, companySymbol: earningCalendar.symbol)
            } else {
                revenueValueLabel.text = "-"
            }

            if let revenueEstimated = earningCalendar.revenueEstimated, revenueEstimated != 0 {
                revenueEstimatedValueLabel.text = convertDoubleToCurrency(amount: revenueEstimated, companySymbol: earningCalendar.symbol)
            } else {
                revenueEstimatedValueLabel.text = "-"
            }
        }
    }

    lazy var cellView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var companySymbolLabel = UILabel().then { label in
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

    lazy var label1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "EPS Estimated".localized()
        label.textAlignment = .left
    }

    lazy var label2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "EPS".localized()
        label.textAlignment = .center
    }

    lazy var label3 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Surprise".localized()
        label.textAlignment = .right
    }

    lazy var stackView2 = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
        sv.spacing = 4
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
        label.textAlignment = .center
    }

    lazy var value3 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.title
        label.textAlignment = .right
    }

    lazy var revenueNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "RevenueTrue".localized()
    }

    lazy var revenueValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var revenueEstimatedNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Revenue Estimated".localized()
    }

    lazy var revenueEstimatedValueLabel = UILabel().then { label in
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

        cellView.addSubview(companySymbolLabel)
        cellView.addSubview(companyValueLabel)

        cellView.addSubview(dateNameLabel)
        cellView.addSubview(dateValueLabel)

        cellView.addSubview(stackView1)
        cellView.addSubview(stackView2)

        cellView.addSubview(label1)
        cellView.addSubview(label2)
        cellView.addSubview(label3)
        cellView.addSubview(value1)
        cellView.addSubview(value2)
        cellView.addSubview(value3)

        cellView.addSubview(revenueNameLabel)
        cellView.addSubview(revenueValueLabel)

        cellView.addSubview(revenueEstimatedNameLabel)
        cellView.addSubview(revenueEstimatedValueLabel)

        let containerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        companySymbolLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(containerInset)
        }
        companyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(companySymbolLabel.snp.bottom).offset(10)
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
        stackView1.addArrangedSubview(label3)

        stackView2.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        stackView2.addArrangedSubview(value1)
        stackView2.addArrangedSubview(value2)
        stackView2.addArrangedSubview(value3)

        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        label2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        label3.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        value1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        value2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        value3.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        revenueEstimatedNameLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        revenueEstimatedValueLabel.snp.makeConstraints { make in
            make.top.equalTo(revenueEstimatedNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(containerInset)
        }

        revenueNameLabel.snp.makeConstraints { make in
            make.top.equalTo(revenueEstimatedValueLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(containerInset)
        }
        revenueValueLabel.snp.makeConstraints { make in
            make.top.equalTo(revenueNameLabel.snp.bottom).offset(10)
            make.bottom.left.right.equalToSuperview().inset(containerInset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
