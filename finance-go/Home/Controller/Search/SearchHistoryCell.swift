//
//  SearchHistoryCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/14.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import TagListView
import Then
import UIKit

class SearchHistoryCell: UITableViewCell {
    var deleteAction: (() -> Void)?

    var searchItem: String? {
        didSet {
            guard let searchItem = searchItem else { return }
            searchLabel.text = searchItem
        }
    }

    lazy var timeImage = UIImageView().then { imageView in
        imageView.image = UIImage(named: "icon_clock")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white2
    }

    lazy var searchLabel = UILabel().then { label in
        label.textColor = .white1
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byTruncatingTail
    }

    lazy var xmarkButton = UIButton().then { button in
        button.setImage(UIImage(named: "icon_xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white2
        button.addTarget(self, action: #selector(xmarkButtonTapped), for: .touchUpInside)
    }
    
    lazy var separatorView = UIView().then { view in
        view.backgroundColor = .white3
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(timeImage)
        contentView.addSubview(searchLabel)
        contentView.addSubview(xmarkButton)
        contentView.addSubview(separatorView)

        timeImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(timeImage.snp.right).offset(16)
            make.right.equalTo(xmarkButton.snp.left).offset(-16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        xmarkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
        }
        separatorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchHistoryCell {
    @objc func xmarkButtonTapped() {
        if let action = deleteAction {
            action()
        }
    }
}
