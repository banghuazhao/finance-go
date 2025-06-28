//
//  HotSearchTagCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/14.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Kingfisher
import TagListView
import Then
import UIKit

protocol HotSearchTagCellDelegate {
    func tagPressed(title: String)
}

class HotSearchTagCell: UITableViewCell {
    var delegate: HotSearchTagCellDelegate?
    var tags: [String]? {
        didSet {
            guard let tags = tags else { return }
            tagListView.removeAllTags()
            tagListView.addTags(tags)
            layoutIfNeeded()
        }
    }

    lazy var tagListView = TagListView().then { tagListView in
        tagListView.tagBackgroundColor = .white4
        tagListView.textColor = .white1
        tagListView.textFont = UIFont.systemFont(ofSize: 16)
        tagListView.cornerRadius = 8
        tagListView.paddingX = 8
        tagListView.paddingY = 6
        tagListView.marginX = 10
        tagListView.marginY = 10
        tagListView.delegate = self
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(tagListView)
        tagListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension HotSearchTagCell: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        delegate?.tagPressed(title: title)
    }
}
