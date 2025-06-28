//
//  EarningCallTranscriptDateCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/31.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class EarningCallTranscriptDateCell: UITableViewCell {
    var earningCallTranscriptDate: EarningCallTranscriptDate? {
        didSet {
            guard let earningCallTranscriptDate = earningCallTranscriptDate else { return }
            timeLabel.text = earningCallTranscriptDate.time
        }
    }

    lazy var docImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "icon_docQuote")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white1
    }

    lazy var timeLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = .normal
    }

    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.tintColor = .white2
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(docImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(rightArrowImageView)

        docImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(docImageView.snp.right).offset(15)
            make.right.equalTo(rightArrowImageView.snp.left).offset(-15)
            make.top.bottom.equalToSuperview().inset(16)
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
