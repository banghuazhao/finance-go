//
//  StockDataMultipleHeaderCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/2.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class StockDataMultipleHeaderCell: UITableViewHeaderFooterView {
    var compare: Bool = true
    var numberOfDatas: Int = 4
    var previousFinancials: [Financial?]?
    var currentFinancials: [Financial?]? {
        didSet {
            guard
                var currentFinancials = currentFinancials, currentFinancials.count > 0,
                var previousFinancials = previousFinancials, previousFinancials.count > 0 else { return }
            titleLabel.attributedText = nil
            currentFinancials.reverse()
            previousFinancials.reverse()

            let currentBeginDate = currentFinancials[0]?.date ?? "-"
            let currentEndDate = currentFinancials[numberOfDatas - 1]?.date ?? "-"
            let previousBeginDate = previousFinancials[0]?.date ?? "-"
            let previousEndDate = previousFinancials[numberOfDatas - 1]?.date ?? "-"

            let currentDateRange = currentBeginDate + " " + "to".localized() + " " + currentEndDate
            let previousDateRange = previousBeginDate + " " + "to".localized() + " " + previousEndDate

            if compare {
                let attributedString = NSMutableAttributedString(
                    attributedString:
                    NSAttributedString(
                        string: "━ ",
                        attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.white1,
                            NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                        ]))

                attributedString.append(NSAttributedString(string: currentDateRange, attributes: [NSAttributedString.Key.paragraphStyle: createParagraphStyle()]))

                attributedString.append(NSAttributedString(string: "\n" + "vs".localized(), attributes:
                    [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                     NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                     NSAttributedString.Key.foregroundColor: UIColor.white2]))

                attributedString.append(NSMutableAttributedString(
                    attributedString:
                    NSAttributedString(
                        string: " ┅ ",
                        attributes: [
                            NSAttributedString.Key.foregroundColor: UIColor.white2,
                            NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                        ])))

                attributedString.append(NSAttributedString(
                    string: previousDateRange,
                    attributes:
                    [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                     NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                     NSAttributedString.Key.foregroundColor: UIColor.white2]))

                titleLabel.attributedText = attributedString

            } else {
                titleLabel.text = currentDateRange
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
