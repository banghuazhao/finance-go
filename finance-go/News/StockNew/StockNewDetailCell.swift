//
//  StockNewDetailCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/2.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import ImageViewer_swift
import Kingfisher
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class StockNewDetailCell: UITableViewCell {
    var stockNew: StockNew? {
        didSet {
            guard let new = stockNew else { return }

            newSiteLabel.text = new.site
            newTitleLabel.text = new.title
            newDateLabel.text = new.date
            newLinkLabel.text = new.url

            // format detail
            let newDetail = new.text == "" ? "No Data".localized() : new.text

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4

            let attributedString = NSAttributedString(string: newDetail, attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            ])

            self.newDetailLabel.attributedText = attributedString

            // load image
            let urlString = new.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            let pictureURL = URL(string: urlString)

            let processor = DownsamplingImageProcessor(
                size: CGSize(width: UIScreen.main.bounds.width,
                             height: UIScreen.main.bounds.height * 0.3))
            newImageView.kf.indicatorType = .activity
            newImageView.kf.setImage(
                with: pictureURL,
                placeholder: UIImage.from(color: .lightGray),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.6)),
                    .cacheOriginalImage,
                    .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
                ]
            )
            newImageView.setupImageViewer(options: [.theme(.dark)], from: parentViewController)
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
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }

    lazy var newDetailLabel = UILabel().then { label in
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 16)
    }

    lazy var newDateLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = UIFont.normal
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }

    lazy var newSiteLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.white2
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }

    lazy var newLinkLabel = UITextView().then { textView in
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.dataDetectorTypes = .all
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }

    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = UIApplication.getTopMostViewController()
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(newImageView)
        contentView.addSubview(newSiteLabel)
        contentView.addSubview(newTitleLabel)
        contentView.addSubview(newDateLabel)

        contentView.addSubview(newDetailLabel)
        contentView.addSubview(newLinkLabel)

        newImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }

        newSiteLabel.snp.makeConstraints { make in
            make.top.equalTo(newImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        newTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(newSiteLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        newDateLabel.snp.makeConstraints { make in
            make.top.equalTo(newTitleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        newDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(newDateLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(20)
        }

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                contentView.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.top.equalTo(newDateLabel.snp.bottom).offset(12)
                    make.height.equalTo(50)
                    make.left.right.equalToSuperview().inset(20)
                }
                newDetailLabel.snp.remakeConstraints { make in
                    make.top.equalTo(bannerView.snp.bottom).offset(18)
                    make.left.right.equalToSuperview().inset(20)
                }
            }
        #endif

        newLinkLabel.snp.makeConstraints { make in
            make.top.equalTo(newDetailLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
