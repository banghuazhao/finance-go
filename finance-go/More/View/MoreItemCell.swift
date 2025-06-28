//
//  MoreItemCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 1/1/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class MoreItemCell: UICollectionViewCell {
    var moreItem: MoreItem? {
        didSet {
            guard let moreItem = moreItem else { return }
            iconView.image = moreItem.icon?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = moreItem.title

            if titleLabel.calculateMaxLines() >= 2 {
                iconView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(18)
                }
                titleLabel.snp.updateConstraints { make in
                    make.top.equalTo(iconView.snp.bottom).offset(10)
                }
            } else {
                iconView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(24)
                }
                titleLabel.snp.updateConstraints { make in
                    make.top.equalTo(iconView.snp.bottom).offset(16)
                }
            }
        }
    }

    lazy var iconView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
    }

    lazy var titleLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.1
        label.textColor = UIColor.white
        label.font = UIFont.normal
        label.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        layer.borderColor = UIColor.white1.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 16

        addSubview(iconView)
        addSubview(titleLabel)

        iconView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - cell animation

extension MoreItemCell {
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
