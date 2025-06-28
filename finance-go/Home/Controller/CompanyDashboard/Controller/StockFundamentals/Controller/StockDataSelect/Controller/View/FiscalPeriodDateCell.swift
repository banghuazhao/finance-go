//
//  FiscalPeriodDateCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class FiscalPeriodDateCell: UICollectionViewCell {
    var isCurrent: Bool = false
    var isCompare: Bool = false

    var isMultiple: Bool = false
    var beginFinancial: Financial?
    
    var financial: Financial? {
        didSet {
            guard let financial = financial else { return }
            if !isMultiple {
                titleLabel.text = financial.date
                if isCurrent {
                    titleLabel.textColor = .navBarColor
                    backgroundColor = UIColor.white1
                } else if isCompare {
                    titleLabel.textColor = .navBarColor
                    backgroundColor = UIColor.white2
                } else {
                    titleLabel.textColor = .white1
                    backgroundColor = UIColor.clear
                }
            } else {
                if let beginFinancial = beginFinancial {
                    titleLabel.text = beginFinancial.date + " " + "to".localized() + " " + financial.date
                } else {
                    titleLabel.text = "- " + "to".localized() + " " + financial.date
                }
                if isCurrent {
                    titleLabel.textColor = .navBarColor
                    backgroundColor = UIColor.white1
                } else if isCompare {
                    titleLabel.textColor = .navBarColor
                    backgroundColor = UIColor.white2
                } else {
                    titleLabel.textColor = .white1
                    backgroundColor = UIColor.clear
                }
            }
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white1
        label.font = UIFont.normal
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.white1.cgColor
        layer.cornerRadius = 8

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
