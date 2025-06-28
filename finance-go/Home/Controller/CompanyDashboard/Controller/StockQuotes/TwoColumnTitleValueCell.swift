//
//  TwoColumnTitleValueCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/19.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class TwoColumnTitleValueCell: UITableViewCell {
    
    var twoColumnTitleValue: TwoColumnTitleValue? {
        didSet {
            guard let twoColumnTitleValue = twoColumnTitleValue else { return }
            titleLabel1.text = twoColumnTitleValue.title1
            titleLabel2.text = twoColumnTitleValue.title2
            valueLabel1.text = twoColumnTitleValue.value1
            valueLabel2.text = twoColumnTitleValue.value2
            link1TextView.text = twoColumnTitleValue.value1
            link2TextView.text = twoColumnTitleValue.value2
            
            if twoColumnTitleValue.isLink1 {
                valueLabel1.isHidden = true
                link1TextView.isHidden = false
            } else {
                valueLabel1.isHidden = false
                link1TextView.isHidden = true
            }
            
            if twoColumnTitleValue.isLink2 {
                valueLabel2.isHidden = true
                link2TextView.isHidden = false
            } else {
                valueLabel2.isHidden = false
                link2TextView.isHidden = true
            }
            
            
        }
    }

    lazy var containerView = UIView()

    lazy var titleLabel1 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = .normal
    }

    lazy var titleLabel2 = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = UIFont.systemFont(ofSize: 16)
    }

    lazy var valueLabel1 = UILabel().then { label in
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = .normal
    }

    lazy var valueLabel2 = UILabel().then { label in
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white1
        label.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var link1TextView = UITextView().then { textView in
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.dataDetectorTypes = .all
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    lazy var link2TextView = UITextView().then { textView in
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.dataDetectorTypes = .all
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainerInset = .zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        

        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
            make.top.bottom.equalToSuperview().inset(8)
        }

        containerView.addSubview(titleLabel1)
        containerView.addSubview(titleLabel2)
        containerView.addSubview(valueLabel1)
        containerView.addSubview(valueLabel2)
        containerView.addSubview(link1TextView)
        containerView.addSubview(link2TextView)

        let ratio = 0.5
        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview().multipliedBy(ratio).offset(-10)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(contentView.snp.right).multipliedBy(ratio).offset(10)
        }

        valueLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.right.equalToSuperview().multipliedBy(ratio).offset(-10)
        }
        
        link1TextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(4)
            make.right.equalToSuperview()
            make.left.equalTo(contentView.snp.right).multipliedBy(ratio).offset(10)
        }
        valueLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(4)
            make.right.equalToSuperview()
            make.left.equalTo(contentView.snp.right).multipliedBy(ratio).offset(10)
        }
        link2TextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(4)
            make.right.equalToSuperview()
            make.left.equalTo(contentView.snp.right).multipliedBy(ratio).offset(10)
        }
        link1TextView.isHidden = true
        link2TextView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
