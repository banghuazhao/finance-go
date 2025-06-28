//
//  SingleStockSplitCalendarTitleCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/1.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class SingleStockSplitCalendarTitleCell: UITableViewCell {

    lazy var stackView = UIStackView().then { sv in
        sv.distribution = .fillProportionally
        sv.axis = .horizontal
    }
    
    lazy var companySymbolLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white1
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.text = "Symbol".localized()
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "Company".localized()
    }

    lazy var label1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "Ratio".localized()
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
        
        stackView.addArrangedSubview(companySymbolLabel)
        stackView.addArrangedSubview(companyNameLabel)
        stackView.addArrangedSubview(label1)
        
        companySymbolLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        label1.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

