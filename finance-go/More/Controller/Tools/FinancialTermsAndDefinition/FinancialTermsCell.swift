//
//  FinancialTermsCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/3/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class FinancialTermsCell: UITableViewCell {
    var financialTerm: FinancialTerm? {
        didSet {
            guard let financialTerm = financialTerm else { return }
            if financialTerm.name == financialTerm.name.localized(using: "FinancialTermsLocalized") {
                titleLabel.text = financialTerm.name
            } else {
                titleLabel.text = "\(financialTerm.name) (\(financialTerm.name.localized(using: "FinancialTermsLocalized")))"
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
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
    }

    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(titleLabel)
        contentView.addSubview(rightArrowImageView)

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
            make.right.equalTo(rightArrowImageView.snp.left).offset(-10)
        }

        rightArrowImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
