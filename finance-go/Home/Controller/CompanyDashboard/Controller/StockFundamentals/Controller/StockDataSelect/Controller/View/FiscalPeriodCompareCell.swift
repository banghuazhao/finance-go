//
//  FiscalPeriodCompareCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

class FiscalPeriodCompareCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white1
        label.font = UIFont.title
        label.text = "Compare with previous".localized()
        return label
    }()
    
    lazy var compareSwitch = UISwitch().then { compareSwitch in
        
    }
    
    lazy var currentLabel = UILabel().then { label in
        label.textColor = .white1
        label.text = "Current".localized()
    }
    
    lazy var currentView = UIView().then { view in
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .white1
    }
    
    lazy var compareLabel = UILabel().then { label in
        label.textColor = .white1
        label.text = "Compare".localized()
    }
    
    lazy var compareView = UIView().then { view in
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .white2
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(compareSwitch)
        contentView.addSubview(titleLabel)
        
        addSubview(currentLabel)
        addSubview(currentView)
        addSubview(compareLabel)
        addSubview(compareView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
        }
        
        compareSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(titleLabel)
        }
        
        currentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        currentView.snp.makeConstraints { make in
            make.left.equalTo(currentLabel.snp.right).offset(10)
            make.centerY.equalTo(currentLabel)
            make.height.equalTo(24)
            make.width.equalTo(40)
        }
        
        compareLabel.snp.makeConstraints { make in
            make.left.equalTo(currentView.snp.right).offset(20)
            make.centerY.equalTo(currentLabel)
        }
        
        compareView.snp.makeConstraints { make in
            make.left.equalTo(compareLabel.snp.right).offset(10)
            make.centerY.equalTo(currentLabel)
            make.height.equalTo(24)
            make.width.equalTo(40)
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
