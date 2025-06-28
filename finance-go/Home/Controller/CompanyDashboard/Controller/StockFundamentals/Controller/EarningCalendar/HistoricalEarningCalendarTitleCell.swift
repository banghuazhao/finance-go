//
//  HistoricalEarningCalendarTitleCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class HistoricalEarningCalendarTitleCell: UITableViewCell {
    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
    }

    lazy var label1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.text = "Date".localized()
    }

    lazy var label2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "EPS Estimated".localized()
    }

    lazy var label3 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "EPS".localized()
    }

    lazy var label4 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "Surprise".localized()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        stackView.addArrangedSubview(label4)

        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        label2.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        label3.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        label4.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
