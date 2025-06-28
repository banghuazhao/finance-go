//
//  EnterpriseValueCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

class CompanyRatingCell: UITableViewCell {
    var companyRating: CompanyRating? {
        didSet {
            guard let companyRating = companyRating else { return }

            if companyRating.ratingRecommendation == "Downloading" {
                overallRatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                overallRatingValueLabel.text = "\("Downloading".localized())..."
                DCFRatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                DCFRatingValueLabel.text = "\("Downloading".localized())..."
                ROERatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                ROERatingValueLabel.text = "\("Downloading".localized())..."
                ROARatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                ROARatingValueLabel.text = "\("Downloading".localized())..."
                DERatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                DERatingValueLabel.text = "\("Downloading".localized())..."
                PERatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                PERatingValueLabel.text = "\("Downloading".localized())..."
                PBRatingValueLabel.textColor = UIColor.black1.alpha(0.5)
                PBRatingValueLabel.text = "\("Downloading".localized())..."
                totalScoreValueLabel.textColor = UIColor.black1.alpha(0.5)
                totalScoreValueLabel.text = "\("Downloading".localized())..."
            } else if companyRating.ratingRecommendation == "No Data" {
                overallRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                overallRatingValueLabel.text = "No Data".localized()
                DCFRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                DCFRatingValueLabel.text = "No Data".localized()
                ROERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                ROERatingValueLabel.text = "No Data".localized()
                ROARatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                ROARatingValueLabel.text = "No Data".localized()
                DERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                DERatingValueLabel.text = "No Data".localized()
                PERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                PERatingValueLabel.text = "No Data".localized()
                PBRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                PBRatingValueLabel.text = "No Data".localized()
                totalScoreValueLabel.textColor = UIColor.black1.alpha(1.0)
                totalScoreValueLabel.text = "No Data".localized()
            } else {
                ratingLabel.text = companyRating.rating
                overallRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                DCFRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                ROERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                ROARatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                DERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                PERatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                PBRatingValueLabel.textColor = UIColor.black1.alpha(1.0)
                totalScoreValueLabel.textColor = UIColor.black1.alpha(1.0)
                overallRatingValueLabel.text = "Score: \(companyRating.ratingScore), \(companyRating.ratingRecommendation)"
                DCFRatingValueLabel.text = "Score: \(companyRating.ratingDetailsDCFScore), \(companyRating.ratingDetailsDCFRecommendation)"
                ROERatingValueLabel.text = "Score: \(companyRating.ratingDetailsROEScore), \(companyRating.ratingDetailsROERecommendation)"
                ROARatingValueLabel.text = "Score: \(companyRating.ratingDetailsROAScore), \(companyRating.ratingDetailsROARecommendation)"
                DERatingValueLabel.text = "Score: \(companyRating.ratingDetailsDEScore), \(companyRating.ratingDetailsDERecommendation)"
                PERatingValueLabel.text = "Score: \(companyRating.ratingDetailsPEScore), \(companyRating.ratingDetailsPERecommendation)"
                PBRatingValueLabel.text = "Score: \(companyRating.ratingDetailsPBScore), \(companyRating.ratingDetailsPBRecommendation)"
                let totalScore = companyRating.ratingDetailsDCFScore + companyRating.ratingDetailsROEScore + companyRating.ratingDetailsROAScore + companyRating.ratingDetailsDEScore + companyRating.ratingDetailsPEScore + companyRating.ratingDetailsPBScore
                totalScoreValueLabel.text = "Score: \(totalScore), \(companyRating.rating)"
            }
        }
    }

    lazy var ratingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white1
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 80)
    }

    lazy var overallRatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var overallRatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Overall Rating"
    }

    lazy var overallRatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var DCFRatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var DCFRatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "DCF"
    }

    lazy var DCFRatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var ROERatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var ROERatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "ROE"
    }

    lazy var ROERatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var ROARatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var ROARatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "ROA"
    }

    lazy var ROARatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var DERatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var DERatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Debt equity ratio"
    }

    lazy var DERatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var PERatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var PERatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Price to earnings ratio"
    }

    lazy var PERatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    lazy var PBRatingView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }

    lazy var PBRatingLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Price to book ratio"
    }

    lazy var PBRatingValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }
    
    lazy var totalScoreView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
    }
    
    lazy var totalScoreLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Total Score".localized()
    }

    lazy var totalScoreValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1.alpha(0.5)
        label.font = UIFont.title
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(ratingLabel)
        contentView.addSubview(overallRatingView)
        contentView.addSubview(DCFRatingView)
        contentView.addSubview(ROERatingView)
        contentView.addSubview(ROARatingView)
        contentView.addSubview(DERatingView)
        contentView.addSubview(PERatingView)
        contentView.addSubview(PBRatingView)
        contentView.addSubview(totalScoreView)

        ratingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60 + 12 + 12)
            make.centerX.equalToSuperview()
        }
        overallRatingView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        DCFRatingView.snp.makeConstraints { make in
            make.top.equalTo(overallRatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        ROERatingView.snp.makeConstraints { make in
            make.top.equalTo(DCFRatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        ROARatingView.snp.makeConstraints { make in
            make.top.equalTo(ROERatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        DERatingView.snp.makeConstraints { make in
            make.top.equalTo(ROARatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        PERatingView.snp.makeConstraints { make in
            make.top.equalTo(DERatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        PBRatingView.snp.makeConstraints { make in
            make.top.equalTo(PERatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }
        totalScoreView.snp.makeConstraints { make in
            make.top.equalTo(PBRatingView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40 + 12 + 12)
        }

        overallRatingView.layer.shadowColor = UIColor.black1.cgColor
        overallRatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        overallRatingView.layer.shadowRadius = 3
        overallRatingView.layer.shadowOpacity = 1
        DCFRatingView.layer.shadowColor = UIColor.black1.cgColor
        DCFRatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        DCFRatingView.layer.shadowRadius = 3
        DCFRatingView.layer.shadowOpacity = 1
        ROERatingView.layer.shadowColor = UIColor.black1.cgColor
        ROERatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        ROERatingView.layer.shadowRadius = 3
        ROERatingView.layer.shadowOpacity = 1
        ROARatingView.layer.shadowColor = UIColor.black1.cgColor
        ROARatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        ROARatingView.layer.shadowRadius = 3
        ROARatingView.layer.shadowOpacity = 1
        DERatingView.layer.shadowColor = UIColor.black1.cgColor
        DERatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        DERatingView.layer.shadowRadius = 3
        DERatingView.layer.shadowOpacity = 1
        PERatingView.layer.shadowColor = UIColor.black1.cgColor
        PERatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        PERatingView.layer.shadowRadius = 3
        PERatingView.layer.shadowOpacity = 1
        PBRatingView.layer.shadowColor = UIColor.black1.cgColor
        PBRatingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        PBRatingView.layer.shadowRadius = 3
        PBRatingView.layer.shadowOpacity = 1
        totalScoreView.layer.shadowColor = UIColor.black1.cgColor
        totalScoreView.layer.shadowOffset = CGSize(width: 0, height: 4)
        totalScoreView.layer.shadowRadius = 3
        totalScoreView.layer.shadowOpacity = 1

        overallRatingView.addSubview(overallRatingLabel)
        overallRatingView.addSubview(overallRatingValueLabel)
        DCFRatingView.addSubview(DCFRatingLabel)
        DCFRatingView.addSubview(DCFRatingValueLabel)
        ROERatingView.addSubview(ROERatingLabel)
        ROERatingView.addSubview(ROERatingValueLabel)
        ROARatingView.addSubview(ROARatingLabel)
        ROARatingView.addSubview(ROARatingValueLabel)
        DERatingView.addSubview(DERatingLabel)
        DERatingView.addSubview(DERatingValueLabel)
        PERatingView.addSubview(PERatingLabel)
        PERatingView.addSubview(PERatingValueLabel)
        PBRatingView.addSubview(PBRatingLabel)
        PBRatingView.addSubview(PBRatingValueLabel)
        totalScoreView.addSubview(totalScoreLabel)
        totalScoreView.addSubview(totalScoreValueLabel)

        overallRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(overallRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(overallRatingView).inset(12)
        }
        overallRatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(overallRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        DCFRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(DCFRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(DCFRatingView).inset(12)
        }

        DCFRatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(DCFRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        ROERatingLabel.snp.makeConstraints { make in
            make.left.equalTo(ROERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(ROERatingView).inset(12)
        }

        ROERatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(ROERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        ROARatingLabel.snp.makeConstraints { make in
            make.left.equalTo(ROARatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(ROARatingView).inset(12)
        }

        ROARatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(ROARatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        DERatingLabel.snp.makeConstraints { make in
            make.left.equalTo(DERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(DERatingView).inset(12)
        }

        DERatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(DERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        PERatingLabel.snp.makeConstraints { make in
            make.left.equalTo(PERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(PERatingView).inset(12)
        }

        PERatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(PERatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        PBRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(PBRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(PBRatingView).inset(12)
        }

        PBRatingValueLabel.snp.makeConstraints { make in
            make.left.equalTo(PBRatingView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        totalScoreLabel.snp.makeConstraints { make in
            make.left.equalTo(totalScoreView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(totalScoreView).inset(12)
        }

        totalScoreValueLabel.snp.makeConstraints { make in
            make.left.equalTo(totalScoreView).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
