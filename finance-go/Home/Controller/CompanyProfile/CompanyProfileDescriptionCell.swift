//
//  CompanyProfileDescriptionCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/20.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class CompanyProfileDescriptionCell: UITableViewCell {
    var companyProfile: CompanyProfile? {
        didSet {
            guard let companyProfile = companyProfile else { return }
            let description = companyProfile.description

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8

            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            ]

            let attributedString = NSAttributedString(string: description, attributes: attributes)

            self.companyDescriptionLabel.attributedText = attributedString
        }
    }

    lazy var companyDescriptionLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.numberOfLines = 0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(companyDescriptionLabel)

        companyDescriptionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
