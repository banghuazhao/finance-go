//
//  StockDataSingleHeaderCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/2.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class StockDataSingleHeaderCell: UITableViewHeaderFooterView {
    var compare: Bool = true
    var previousFinancial: Financial?
    var currentFinancial: Financial? {
        didSet {
            guard let currentFinancial = currentFinancial else { return }
            titleLabel.attributedText = nil
            if compare {
                if let previousFinancial = previousFinancial {
                    let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: currentFinancial.date, attributes: [NSAttributedString.Key.paragraphStyle: createParagraphStyle()]))
                    attributedString.append(NSAttributedString(
                        string: "\n" + "vs".localized() + " " + previousFinancial.date,
                        attributes:
                        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                         NSAttributedString.Key.foregroundColor: UIColor.white2]))
                    titleLabel.attributedText = attributedString

                } else {
                    let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: currentFinancial.date, attributes: [NSAttributedString.Key.paragraphStyle: createParagraphStyle()]))
                    attributedString.append(NSAttributedString(
                        string: "\n" + "vs".localized() + " " + "-",
                        attributes:
                        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                         NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                         NSAttributedString.Key.foregroundColor: UIColor.white2]))
                    titleLabel.attributedText = attributedString
                }
            } else {
                titleLabel.text = currentFinancial.date
            }
        }
    }

    lazy var calendarImageView = UIImageView().then { imageView in
        imageView.tintColor = UIColor.white1
        imageView.image = UIImage(named: "calendars")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
    }

    lazy var titleLabel = UILabel().then { label in
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
    }

    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.tintColor = UIColor.white1
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .navBarColor
        contentView.backgroundColor = .navBarColor

        contentView.addSubview(titleLabel)
        contentView.addSubview(calendarImageView)
        contentView.addSubview(rightArrowImageView)

        calendarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(calendarImageView.snp.right).offset(16)
            make.right.equalTo(rightArrowImageView.snp.left).offset(-16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        titleLabel.text = " "
        rightArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(16)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
