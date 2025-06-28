//
//  SectionTitleHeader.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class SectionTitleHeader: UITableViewHeaderFooterView {
    
    var moreButtonAction: (()->Void)? {
        didSet {
            if moreButtonAction == nil {
                showAllButton.isHidden = true
                rightArrowImageView.isHidden = true
            } else {
                showAllButton.isHidden = false
                rightArrowImageView.isHidden = false
            }
        }
    }
    
    var titleText: String? {
        didSet {
            guard let titleText = titleText else {
                return
            }
            titleLabel.text = titleText
        }
    }
        
    lazy var titleLabel = UILabel().then { label in
        label.textColor = .white
        label.font = .bigTitle
    }

    lazy var showAllButton = UIButtonLargerTouchArea().then { button in
        button.setAttributedTitle(
            NSAttributedString(
                string: "More".localized(),
                attributes: [
                    NSAttributedString.Key.font: UIFont.title,
                    NSAttributedString.Key.foregroundColor: UIColor.white1,
                ]),
            for: .normal)
        button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
    }
    
    lazy var rightArrowImageView = UIImageView().then { imageView in
        imageView.tintColor = UIColor.white1
        imageView.image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate)
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(showMore))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.contentMode = .scaleAspectFit
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        tintColor = .clear
                
        contentView.addSubview(titleLabel)
        contentView.addSubview(showAllButton)
        contentView.addSubview(rightArrowImageView)

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(30)
        }
        
        rightArrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(16)
        }
        
        showAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(rightArrowImageView.snp.left)
        }
        showAllButton.isHidden = true
        rightArrowImageView.isHidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: -  actions
extension SectionTitleHeader {
    @objc func showMore() {
        if let action = moreButtonAction {
            action()
        }
    }
}
