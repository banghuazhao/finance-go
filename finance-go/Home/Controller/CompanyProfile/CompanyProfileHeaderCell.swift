//
//  CompanyProfileHeaderCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/16.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit
import Kingfisher

class CompanyProfileHeaderCell: UITableViewCell {
    var company: Company? {
        didSet {
            guard let company = company else { return }
            companySymbolLabel.text = company.symbol
            companyNameLabel.text = company.name
            
            let urlString = "https://financialmodelingprep.com/images-New-jpg/\(company.symbol).jpg".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            let pictureURL = URL(string: urlString)

            let processor = DownsamplingImageProcessor(size: CGSize(width: 48, height: 48))
            companyIconView.kf.indicatorType = .activity
            companyIconView.kf.setImage(
                with: pictureURL,
                placeholder: UIImage(named: "select_photo_empty")?.maskWithColor(color: .white2),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.6)),
                    .cacheOriginalImage,
                    .diskCacheExpiration(.days(180)),
                    .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
                ]
            )
        }
    }
    
    lazy var companyIconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }

    lazy var companySymbolLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.font = UIFont.boldSystemFont(ofSize: 28)
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(companyIconView)
        contentView.addSubview(companySymbolLabel)
        contentView.addSubview(companyNameLabel)

        companyIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(48)
        }
        
        companySymbolLabel.snp.makeConstraints { make in
            make.centerY.equalTo(companyIconView)
            make.left.equalTo(companyIconView.snp.right).offset(20)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyIconView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-16)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
