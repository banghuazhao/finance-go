//
//  StockGradeCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class StockGradeCell: UITableViewCell {
    var stockGrade: StockGrade? {
        didSet {
            guard let stockGrade = stockGrade else { return }

            companyNameValueLabel.text = stockGrade.gradingCompany
            
            if CompanyStore.shared.item(companyName: stockGrade.gradingCompany) != nil {
                companyNameValueLabel.textColor = UIColor.systemBlue
            } else {
                companyNameValueLabel.textColor = UIColor.black
            }

            if let dateString = Date.convertStringyyyyMMddToDate(string: stockGrade.date)?.stringDayyyyyMMdd {
                dateReportedValueLabel.text = dateString
            } else {
                dateReportedValueLabel.text = stockGrade.date
            }

            gradeValueLabel.text = "\(stockGrade.previousGrade) to \(stockGrade.newGrade)"
            upOrDownValueLabel.text = stockGrade.upOrDown
            upOrDownValueLabel.textColor = stockGrade.color
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
        label.text = "Grading Company".localized()
    }

    lazy var companyNameValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(nameTapped))
        label.addGestureRecognizer(tapGestureRecognizer)
    }

    lazy var dateReportedNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Date".localized()
    }

    lazy var dateReportedValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var gradeNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Grade".localized()
    }

    lazy var gradeValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var upOrDownNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Upgrades & Downgrades".localized()
    }

    lazy var upOrDownValueLabel = UILabel().then { label in
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

        cellView.addSubview(companyNameLabel)
        cellView.addSubview(companyNameValueLabel)
        cellView.addSubview(dateReportedNameLabel)
        cellView.addSubview(dateReportedValueLabel)
        cellView.addSubview(gradeNameLabel)
        cellView.addSubview(gradeValueLabel)
        cellView.addSubview(upOrDownNameLabel)
        cellView.addSubview(upOrDownValueLabel)

        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cellView).inset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        companyNameValueLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        dateReportedNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameValueLabel.snp.bottom).offset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        dateReportedValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateReportedNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        gradeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(dateReportedValueLabel.snp.bottom).offset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        gradeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(gradeNameLabel.snp.bottom).offset(8)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }

        upOrDownNameLabel.snp.makeConstraints { make in
            make.top.equalTo(gradeValueLabel.snp.bottom).offset(16)
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        upOrDownValueLabel.snp.makeConstraints { make in
            make.top.equalTo(upOrDownNameLabel.snp.bottom).offset(8)
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

extension StockGradeCell {
    @objc func nameTapped() {
        guard let stockGrade = stockGrade else { return }
        if let company = CompanyStore.shared.item(companyName: stockGrade.gradingCompany) {
            let companyDashboardViewController = CompanyDashboardViewController()
            companyDashboardViewController.company = company
            parentViewController?.navigationController?.pushViewController(companyDashboardViewController, animated: true)
        }
    }
}
