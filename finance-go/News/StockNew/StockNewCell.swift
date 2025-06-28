//
//  StockNewCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 9/14/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

class StockNewCell: UITableViewCell {
    var stockNew: StockNew? {
        didSet {
            guard let new = stockNew else { return }

            newSiteLabel.text = new.site
            newTitleLabel.text = new.title

            newDateLabel.text = new.date
            newSymbolLabel.text = new.symbol

            if newSymbolLabel.text == "No Data".localized() {
                newSymbolLabel.isHidden = true
                newDateLabel.snp.remakeConstraints { make in
                    make.top.equalTo(newTitleLabel.snp.bottom).offset(12)
                    make.left.equalToSuperview().offset(20)
                }
            } else {
                newSymbolLabel.isHidden = false
                newDateLabel.snp.remakeConstraints { make in
                    make.top.equalTo(newTitleLabel.snp.bottom).offset(12)
                    make.left.equalTo(newSymbolLabel.snp.right).offset(12)
                }
            }

            let urlString = new.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            let pictureURL = URL(string: urlString)

            let processor = DownsamplingImageProcessor(size: CGSize(width: 72, height: 72))
            newImageView.kf.indicatorType = .activity
            newImageView.kf.setImage(
                with: pictureURL,
                placeholder: UIImage(named: "news_photo_placeholder"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.6)),
                    .cacheOriginalImage,
                    .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
                ]
            )
        }
    }

    var hasSeparator: Bool = false {
        didSet {
            if hasSeparator {
                separatorView.isHidden = false
            } else {
                separatorView.isHidden = true
            }
        }
    }

    lazy var newImageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
    }

    lazy var newTitleLabel = UILabel().then { label in
        label.textColor = UIColor.white
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }

    lazy var newDateLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = UIFont.normal
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    lazy var newSymbolLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.font = UIFont.normal
    }

    lazy var newSiteLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    lazy var separatorView = UIView().then { view in
        view.backgroundColor = .white3
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(newImageView)
        contentView.addSubview(newSiteLabel)
        contentView.addSubview(newTitleLabel)
        contentView.addSubview(newDateLabel)
        contentView.addSubview(newSymbolLabel)
        contentView.addSubview(separatorView)

        newImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(72)
            make.centerY.equalToSuperview()
        }

        newTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(newImageView.snp.left).offset(-12)
        }

        newSymbolLabel.snp.makeConstraints { make in
            make.top.equalTo(newTitleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }

        newDateLabel.snp.makeConstraints { make in
            make.top.equalTo(newTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(newSymbolLabel.snp.right).offset(12)
        }

        newSiteLabel.snp.makeConstraints { make in
            make.top.equalTo(newDateLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(newImageView.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-16)
        }
        separatorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        separatorView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
