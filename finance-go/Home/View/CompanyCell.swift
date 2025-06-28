//
//  CompanyCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/23/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Kingfisher
import Then
import UIKit

func imageWith(name: String?) -> UIImage? {
    let frame = CGRect(x: 0, y: 0, width: 48 * 3, height: 48 * 3)
    let nameLabel = UILabel(frame: frame)
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = .navBarColor
    nameLabel.textColor = .white
    nameLabel.font = UIFont.boldSystemFont(ofSize: 80)
    nameLabel.text = name
    UIGraphicsBeginImageContext(frame.size)
    if let currentContext = UIGraphicsGetCurrentContext() {
        nameLabel.layer.render(in: currentContext)
        let nameImage = UIGraphicsGetImageFromCurrentImageContext()
        return nameImage
    }
    return nil
}

class CompanyCell: UITableViewCell {
    var company: Company? {
        didSet {
            guard let company = company else { return }

            companyNameLabel.attributedText = nil
            companySymbolLabel.attributedText = nil

            companyNameLabel.text = company.name
            companySymbolLabel.text = company.symbol

            if let price = company.price {
                if ![ValueType.index, .forex].contains(company.type) {
                    priceLabel.text = price.convertToCurrency(localeIdentifier: company.localeIdentifier)
                } else {
                    priceLabel.text = price.decimalTwoDigitsString
                }
            } else {
                priceLabel.text = ""
            }
            likeButton.tintColor = company.isWatched ? UIColor.orange1 : UIColor.systemGray

            if ![ValueType.stock, ValueType.fund, ValueType.etf].contains(company.type) {
                infoButton.isHidden = true
                likeButton.snp.updateConstraints { make in
                    make.centerY.equalToSuperview()
                }
            } else {
                infoButton.isHidden = false
                infoButton.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(-16)
                }
                likeButton.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(16)
                }
            }

            if let percentChange = company.changesPercentage {
                percentChangeLabel.isHidden = false
                if percentChange > 0 {
                    percentChangeLabel.text = " " + "+" + String(format: "%.2f%%", percentChange) + " "
                    percentChangeLabel.textColor = .increaseNumberGreen
                    percentChangeLabel.backgroundColor = UIColor(hex: "D6FFEF")
                } else if percentChange == 0 {
                    percentChangeLabel.text = " " + String(format: "%.2f%%", 0) + " "
                    percentChangeLabel.textColor = UIColor(hex: "585858")
                    percentChangeLabel.backgroundColor = UIColor(hex: "D3D3D3")
                } else {
                    percentChangeLabel.text = " " + String(format: "%.2f%%", percentChange) + " "
                    percentChangeLabel.textColor = .decreaseNumberRed
                    percentChangeLabel.backgroundColor = UIColor(hex: "FFDEDE")
                }
            } else {
                percentChangeLabel.isHidden = true
            }

            if [ValueType.stock, .etf, .fund].contains(company.type) {
                let urlString = "https://financialmodelingprep.com/images-New-jpg/\(company.symbol).jpg".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                let pictureURL = URL(string: urlString)

                let processor = DownsamplingImageProcessor(size: CGSize(width: 48, height: 48))
                companyIconView.kf.indicatorType = .activity
                companyIconView.kf.setImage(
                    with: pictureURL,
                    placeholder: UIImage(named: "select_photo_empty"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.6)),
                        .cacheOriginalImage,
                        .diskCacheExpiration(.days(180)),
                        .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
                    ]
                )
            } else if company.type == .cryptocurrency {
                if let image = UIImage(named: company.symbol) {
                    companyIconView.image = image
                } else {
                    companyIconView.image = imageWith(name: String(company.name.prefix(1)))
                }
            } else {
                companyIconView.image = imageWith(name: String(company.name.prefix(1)))
            }
        }
    }

    var searchText: String = "" {
        didSet {
            if let companyName = company?.name {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: companyName)

                let range: NSRange = (companyName as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange1, range: range)

                companyNameLabel.attributedText = attrString
            }

            if let companyCode = company?.symbol {
                let attrString: NSMutableAttributedString = NSMutableAttributedString(string: companyCode)

                let range: NSRange = (companyCode as NSString).range(of: searchText, options: [NSString.CompareOptions.caseInsensitive])

                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange2, range: range)

                companySymbolLabel.attributedText = attrString
            }
        }
    }

    lazy var companyView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
    }

    lazy var companyIconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }

    lazy var symbolStackView = UIStackView().then { sv in
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 2
    }

    lazy var companySymbolLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.title
    }

    lazy var percentChangeLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
    }

    lazy var priceLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 14)
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black2
        label.font = UIFont.normal
    }

    lazy var likeButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "icon_star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(self, action: #selector(likeAction(_:)), for: .touchUpInside)
        b.tintColor = .systemGray
    }

    lazy var infoButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(self, action: #selector(companyInfo), for: .touchUpInside)
        b.tintColor = .systemGray
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.autoresizingMask = .flexibleHeight

        contentView.addSubview(companyView)
        companyView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48 + 16 + 16).priority(999)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }

        companyView.layer.shadowColor = UIColor.black1.cgColor
        companyView.layer.shadowOffset = CGSize(width: 0, height: 4)
        companyView.layer.shadowRadius = 4
        companyView.layer.shadowOpacity = 1

        companyView.addSubview(companyIconView)
        companyView.addSubview(symbolStackView)
        companyView.addSubview(companyNameLabel)
        companyView.addSubview(infoButton)
        companyView.addSubview(likeButton)

        companyIconView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }

        symbolStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(companyIconView.snp.right).offset(12)
            make.right.equalTo(likeButton.snp.left).offset(-12)
            make.height.equalTo(30)
        }

        infoButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().offset(-16)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().offset(16)
        }

        symbolStackView.addArrangedSubview(companySymbolLabel)
        symbolStackView.addArrangedSubview(percentChangeLabel)
        symbolStackView.addArrangedSubview(priceLabel)

        companySymbolLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.32)
        }

        percentChangeLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.32)
        }

        priceLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.34)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(symbolStackView.snp.bottom).offset(2)
            make.left.equalTo(companyIconView.snp.right).offset(12)
            make.right.equalTo(likeButton.snp.left).offset(-12)
            make.height.equalTo(30)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension CompanyCell {
    @objc func companyInfo() {
        let comanpyProfileViewController = CompanyProfileViewController()
        comanpyProfileViewController.company = company
        parentViewController?.navigationController?.pushViewController(comanpyProfileViewController, animated: true)
    }

    @objc func likeAction(_ sender: UIButton) {
        guard let company = company else { return }

        if !company.isWatched {
            ImpactManager.shared.generate()
            sender.tintColor = UIColor.orange1
            WatchCompanyHelper.appendWatchCompanySymbol(company: company)
            parentViewController?.view.makeToast("Watchlist added".localized() + " " + company.symbol, duration: 1.0)
            NotificationCenter.default.post(name: .didAddWatchCompany, object: company)
        } else {
            ImpactManager.shared.generate()
            sender.tintColor = UIColor.systemGray
            WatchCompanyHelper.removeWatchCompanySymbol(company: company)
            parentViewController?.view.makeToast("Watch list removed".localized() + " " + company.symbol, duration: 1.0)
            NotificationCenter.default.post(name: .didRemoveWatchCompany, object: company)
        }
    }
}

// MARK: - cell animation

extension CompanyCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(highlight: true)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        animate(highlight: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(highlight: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(highlight: false)
    }

    func animate(highlight: Bool) {
        if highlight {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction) {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } completion: { _ in
            }

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction) {
                self.transform = .identity
            } completion: { _ in
            }
        }
    }
}
