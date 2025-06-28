//
//  NativeNewsAdCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 8/8/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds

    import Then
    import UIKit

    class NativeNewsAdCell: UITableViewCell {
        var nativeAd: GADNativeAd? {
            didSet {
                guard let nativeAd = nativeAd else { return }
                nativeAdView.nativeAd = nativeAd
                iconView.image = nativeAd.icon?.image
                headlineLabel.text = nativeAd.headline
                bodyLabel.text = nativeAd.body
                storeLabel.text = nativeAd.store
                if let starRating = nativeAd.starRating {
                    starRatingLabel.text = String(describing: starRating)
                } else {
                    starRatingLabel.text = ""
                }
                callToActionView.setAttributedTitle(
                    NSAttributedString(
                        string: nativeAd.callToAction ?? "Install",
                        attributes: [
                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                            NSAttributedString.Key.foregroundColor: UIColor.white1,
                        ]
                    ), for: .normal)

                callToActionView.isHidden = nativeAd.callToAction == nil
                callToActionView.isUserInteractionEnabled = false
            }
        }

        lazy var adLabel = UILabel().then { label in
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.numberOfLines = 1
            label.textAlignment = .center
            label.text = "Ad"
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.white1.cgColor
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 4
        }

        lazy var nativeAdView = GADNativeAdView().then { view in
            view.backgroundColor = .clear
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

        lazy var iconView = UIImageView().then { imageView in
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
        }

        lazy var headlineLabel = UILabel().then { label in
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 3
            label.lineBreakMode = .byTruncatingTail
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }

        lazy var bodyLabel = UILabel().then { label in
            label.textColor = UIColor.white
            label.numberOfLines = 3
            label.font = UIFont.normal
            label.font = UIFont.systemFont(ofSize: 14)
        }

        lazy var callToActionView = UIButton(type: .system).then { button in
            button.setAttributedTitle(
                NSAttributedString(
                    string: "Install",
                    attributes: [
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: UIColor.white1,
                    ]
                ), for: .normal)
        }

        lazy var storeLabel = UILabel().then { label in
            label.textColor = UIColor.white2
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 13)
        }

        lazy var starRatingLabel = UILabel().then { label in
            label.textColor = UIColor.white2
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: 13)
        }

        lazy var separatorView = UIView().then { view in
            view.backgroundColor = .white3
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            selectionStyle = .none

            contentView.addSubview(nativeAdView)

            nativeAdView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.left.right.equalToSuperview().inset(20)
            }

            nativeAdView.addSubview(adLabel)
            nativeAdView.addSubview(iconView)
            nativeAdView.addSubview(headlineLabel)
            nativeAdView.addSubview(bodyLabel)
            nativeAdView.addSubview(callToActionView)
            nativeAdView.addSubview(storeLabel)
            nativeAdView.addSubview(starRatingLabel)
            contentView.addSubview(separatorView)

            iconView.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.size.equalTo(72)
                make.centerY.equalToSuperview()
            }

            headlineLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.left.equalToSuperview()
                make.right.equalTo(iconView.snp.left).offset(-16)
            }

            bodyLabel.snp.makeConstraints { make in
                make.top.equalTo(headlineLabel.snp.bottom).offset(12)
                make.left.equalToSuperview()
                make.right.equalTo(iconView.snp.left).offset(-16)
            }

            adLabel.snp.makeConstraints { make in
                make.top.equalTo(bodyLabel.snp.bottom).offset(12)
                make.height.equalTo(16)
                make.width.equalTo(21)
                make.bottom.equalToSuperview().offset(-16)
            }

            callToActionView.snp.makeConstraints { make in
                make.centerY.equalTo(adLabel)
                make.left.equalTo(adLabel.snp.right).offset(12)
            }

            storeLabel.snp.makeConstraints { make in
                make.centerY.equalTo(adLabel)
                make.left.equalTo(callToActionView.snp.right).offset(12)
            }

            starRatingLabel.snp.makeConstraints { make in
                make.centerY.equalTo(adLabel)
                make.left.equalTo(storeLabel.snp.right).offset(12)
            }

            nativeAdView.headlineView = headlineLabel
            nativeAdView.iconView = iconView
            nativeAdView.bodyView = bodyLabel
            nativeAdView.callToActionView = callToActionView
            nativeAdView.storeView = storeLabel
            nativeAdView.starRatingView = starRatingLabel

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
#endif
