//
//  HolderProfileCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class HolderProfileCell: UITableViewCell {
    var holderProfile: HolderProfile? {
        didSet {
            guard let holderProfile = holderProfile else { return }

            holderNameValueLabel.text = holderProfile.holderName
            if CompanyStore.shared.item(companyName: holderProfile.holderName) != nil {
                holderNameValueLabel.textColor = UIColor.systemBlue
            } else {
                holderNameValueLabel.textColor = UIColor.black
            }

            if let dateString = Date.convertStringyyyyMMddToDate(string: holderProfile.dateReported)?.stringDayyyyyMMdd {
                dateReportedValueLabel.text = dateString
            } else {
                dateReportedValueLabel.text = holderProfile.dateReported
            }

            let shares: Double = Double(holderProfile.shares)
            let changes: Double = Double(holderProfile.change)
            let changePercent: Double = changes / shares * 100

            let sharesString = convertDoubleToDecimal(amount: shares)
            let changesString = changes >= 0 ? "+" + convertDoubleToDecimal(amount: changes) : convertDoubleToDecimal(amount: changes)
            let changePercentString = changes >= 0 ? "(↑" + convertDoubleToDecimal(amount: changePercent) + "%)" : "(↓" + convertDoubleToDecimal(amount: fabs(changePercent)) + "%)"
            let changesStringAll = changesString + " " + changePercentString

            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: sharesString))
            attributedString.append(NSAttributedString(
                string: "  " + changesStringAll,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                             NSAttributedString.Key.foregroundColor: changes >= 0 ? UIColor.increaseNumberGreen : UIColor.decreaseNumberRed]))
            sharesValueLabel.attributedText = attributedString
        }
    }

    lazy var cellView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var holderNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Holder".localized()
        
    }

    lazy var holderNameValueLabel = UILabel().then { label in
        label.numberOfLines = 0
        label.textColor = UIColor.black1
        label.font = UIFont.title
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(nameTapped))
        label.addGestureRecognizer(tapGestureRecognizer)
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

    lazy var dateReportedNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Date Reported".localized()
    }

    lazy var dateReportedValueLabel = UILabel().then { label in
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
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        cellView.layer.shadowColor = UIColor.black1.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 1

        cellView.addSubview(holderNameLabel)
        cellView.addSubview(holderNameValueLabel)
        cellView.addSubview(dateReportedNameLabel)
        cellView.addSubview(dateReportedValueLabel)
        cellView.addSubview(sharesNameLabel)
        cellView.addSubview(sharesValueLabel)

        holderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cellView).inset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        holderNameValueLabel.snp.makeConstraints { make in
            make.top.equalTo(holderNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        dateReportedNameLabel.snp.makeConstraints { make in
            make.top.equalTo(holderNameValueLabel.snp.bottom).offset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        dateReportedValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateReportedNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        sharesNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateReportedValueLabel.snp.bottom).offset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        sharesValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sharesNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension HolderProfileCell {
    @objc func nameTapped() {
        guard let holderProfile = holderProfile else { return }
        if let company = CompanyStore.shared.item(companyName: holderProfile.holderName) {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = company
            parentViewController?.navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }
}
