//
//  EarningCallTranscriptCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class EarningCallTranscriptCell: UITableViewCell {
    var earningCallTranscript: EarningCallTranscript? {
        didSet {
            guard let earningCallTranscript = earningCallTranscript else { return }

            timeValueLabel.text = earningCallTranscript.date

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8

            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            ]
            let descriptionValueData = earningCallTranscript.content
            let attributedString = NSAttributedString(string: descriptionValueData, attributes: attributes)

            contentValueLabel.attributedText = attributedString
        }
    }

    lazy var timeValueLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.title
    }

    lazy var contentValueLabel = UILabel().then { label in
        label.numberOfLines = 0
        label.textColor = UIColor.white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(timeValueLabel)
        contentView.addSubview(contentValueLabel)

        timeValueLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }

        contentValueLabel.snp.makeConstraints { make in
            make.top.equalTo(timeValueLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
