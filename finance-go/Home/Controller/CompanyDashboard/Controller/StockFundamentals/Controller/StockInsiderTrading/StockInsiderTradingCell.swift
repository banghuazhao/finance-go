//
//  StockInsiderTradingCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class StockInsiderTradingCell: UITableViewCell {
    var stockInsiderTrading: StockInsiderTrading? {
        didSet {
            guard let stockInsiderTrading = stockInsiderTrading else { return }
            transactionDateValueLabel.text = stockInsiderTrading.transactionDate
            reportingCikValueLabel.text = stockInsiderTrading.reportingCik
            transactionTypeValueLabel.text = stockInsiderTrading.transactionType
            if let securitiesOwned = stockInsiderTrading.securitiesOwned {
                securitiesOwnedValueLabel.text = convertDoubleToDecimal(amount: securitiesOwned)
            } else {
                securitiesOwnedValueLabel.text = "No Data".localized()
            }
            companyCikValueLabel.text = stockInsiderTrading.companyCik
            reportingNameValueLabel.text = stockInsiderTrading.reportingName
            typeOfOwnerValueLabel.text = stockInsiderTrading.typeOfOwner
            acquistionOrDispositionValueLabel.text = stockInsiderTrading.acquistionOrDisposition
            formTypeValueLabel.text = stockInsiderTrading.formType
            if let securitiesTransacted = stockInsiderTrading.securitiesTransacted {
                securitiesTransactedValueLabel.text = convertDoubleToDecimal(amount: securitiesTransacted)
            } else {
                securitiesTransactedValueLabel.text = "No Data".localized()
            }
            securityNameValueLabel.text = stockInsiderTrading.securityName
            linkValueLabel.text = stockInsiderTrading.link
        }
    }

    lazy var cellView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    // labels

    lazy var transactionDateLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Transaction Date".localized()
    }

    lazy var reportingCikLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Reporting CIK".localized()
    }

    lazy var transactionTypeLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Transaction Type".localized()
    }

    lazy var securitiesOwnedLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Securities Owned".localized()
    }

    lazy var companyCikLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Company CIK".localized()
    }

    lazy var reportingNameLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Reporting Name".localized()
    }

    lazy var typeOfOwnerLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Type of Owner".localized()
    }

    lazy var acquistionOrDispositionLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Acquistion or Disposition".localized()
    }

    lazy var formTypeLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Form Type".localized()
    }

    lazy var securitiesTransactedLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Securities Transacted".localized()
    }

    lazy var securityNameLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Security Name".localized()
    }

    lazy var linkLabel = UILabel().then { label in
        label.textColor = .black1
        label.font = .systemFont(ofSize: 13)
        label.text = "Link".localized()
    }

    // values
    lazy var symbolValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var transactionDateValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var reportingCikValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var transactionTypeValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var securitiesOwnedValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var companyCikValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var reportingNameValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var typeOfOwnerValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var acquistionOrDispositionValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var formTypeValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var securitiesTransactedValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var securityNameValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .black1
        label.font = .title
    }

    lazy var linkValueLabel = UITextView().then { textView in
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textColor = .black1
        textView.font = .normal
        textView.dataDetectorTypes = .all
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        cellView.layer.shadowColor = UIColor.black1.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 1

        cellView.addSubview(transactionDateLabel)
        cellView.addSubview(reportingCikLabel)
        cellView.addSubview(transactionTypeLabel)
        cellView.addSubview(securitiesOwnedLabel)
        cellView.addSubview(companyCikLabel)
        cellView.addSubview(reportingNameLabel)
        cellView.addSubview(typeOfOwnerLabel)
        cellView.addSubview(acquistionOrDispositionLabel)
        cellView.addSubview(formTypeLabel)
        cellView.addSubview(securitiesTransactedLabel)
        cellView.addSubview(securityNameLabel)
        cellView.addSubview(linkLabel)

        cellView.addSubview(transactionDateValueLabel)
        cellView.addSubview(reportingCikValueLabel)
        cellView.addSubview(transactionTypeValueLabel)
        cellView.addSubview(securitiesOwnedValueLabel)
        cellView.addSubview(companyCikValueLabel)
        cellView.addSubview(reportingNameValueLabel)
        cellView.addSubview(typeOfOwnerValueLabel)
        cellView.addSubview(acquistionOrDispositionValueLabel)
        cellView.addSubview(formTypeValueLabel)
        cellView.addSubview(securitiesTransactedValueLabel)
        cellView.addSubview(securityNameValueLabel)
        cellView.addSubview(linkValueLabel)

        transactionDateLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(cellView).inset(12)
        }
        transactionDateValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(transactionDateLabel.snp.bottom).offset(12)
        }
        reportingCikLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(transactionDateValueLabel.snp.bottom).offset(12)
        }
        reportingCikValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(reportingCikLabel.snp.bottom).offset(12)
        }
        transactionTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(reportingCikValueLabel.snp.bottom).offset(12)
        }
        transactionTypeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(transactionTypeLabel.snp.bottom).offset(12)
        }
        securitiesOwnedLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(transactionTypeValueLabel.snp.bottom).offset(12)
        }
        securitiesOwnedValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securitiesOwnedLabel.snp.bottom).offset(12)
        }
        companyCikLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securitiesOwnedValueLabel.snp.bottom).offset(12)
        }
        companyCikValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(companyCikLabel.snp.bottom).offset(12)
        }
        reportingNameLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(companyCikValueLabel.snp.bottom).offset(12)
        }
        reportingNameValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(reportingNameLabel.snp.bottom).offset(12)
        }
        typeOfOwnerLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(reportingNameValueLabel.snp.bottom).offset(12)
        }
        typeOfOwnerValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(typeOfOwnerLabel.snp.bottom).offset(12)
        }
        acquistionOrDispositionLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(typeOfOwnerValueLabel.snp.bottom).offset(12)
        }
        acquistionOrDispositionValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(acquistionOrDispositionLabel.snp.bottom).offset(12)
        }
        formTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(acquistionOrDispositionValueLabel.snp.bottom).offset(12)
        }
        formTypeValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(formTypeLabel.snp.bottom).offset(12)
        }
        securitiesTransactedLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(formTypeValueLabel.snp.bottom).offset(12)
        }
        securitiesTransactedValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securitiesTransactedLabel.snp.bottom).offset(12)
        }
        securityNameLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securitiesTransactedValueLabel.snp.bottom).offset(12)
        }
        securityNameValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securityNameLabel.snp.bottom).offset(12)
        }
        linkLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(securityNameValueLabel.snp.bottom).offset(12)
        }
        linkValueLabel.snp.makeConstraints { make in
            make.left.equalTo(cellView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(linkLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
