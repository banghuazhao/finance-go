//
//  FinancialDefinitionCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/18.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class FinancialDefinitionCell: UITableViewCell {
    var financialTerm: FinancialTerm? {
        didSet {
            guard let financialTerm = financialTerm else {
                return
            }
            if financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") {
                titleLabel.text = financialTerm.name
            } else {
                titleLabel.text = "\(financialTerm.name)\n\(financialTerm.name.localized(using: "FinancialTermsLocalized"))"
            }

            if financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") {
                definitionTextView.text = financialTermsDict[financialTerm.name]
            } else {
                definitionTextView.text = "\(financialTermsDict[financialTerm.name] ?? "")\n\n\((financialTermsDict[financialTerm.name] ?? "").localized(using: "FinancialTermsLocalized"))"
            }
        }
    }

    var searchText: String = "" {
        didSet {
            guard let financialTerm = financialTerm else { return }

            let titleText = financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") ? financialTerm.name : "\(financialTerm.name) (\(financialTerm.name.localized(using: "FinancialTermsLocalized")))"

            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: titleText)

            let range: NSRange = (titleText as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemOrange, range: range)

            titleLabel.attributedText = attrString
        }
    }

    lazy var titleLabel = UILabel().then { label in
        label.font = .bigTitle
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
    }

    lazy var definitionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .normal
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.dataDetectorTypes = .all
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(titleLabel)
        contentView.addSubview(definitionTextView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(60)
        }

        definitionTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-30)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
