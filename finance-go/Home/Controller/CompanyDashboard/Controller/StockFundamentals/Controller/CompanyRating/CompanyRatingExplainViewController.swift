//
//  CompanyRatingExplainViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/24.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class CompanyRatingExplainViewController: FGUIViewController {
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    override var isStaticBackground: Bool {
        return true
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var titleLabel1 = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.text = "1. Assumptions"
    }

    lazy var titleLabel2 = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.text = "2. Individual Calculations"
    }

    lazy var titleLabel3 = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.text = "3. Main Rating Calculations"
    }

    private lazy var explainLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white1

        let text = """
        DCF: [ 0.3, 0.05, -0.1, -0.3 ]
        ROE: [ 0.3, 0.05, -0.1, -0.3 ]
        ROA: [ 0.3, 0.05, -0.1, -0.3 ]
        Debt to equity ratio: [ 2, 0.5, -0.5, -3 ]
        Price to earnings ratio: [ 8, 0.5, -0.5, -3 ]
        Price to book ratio: [ 1, 0.5, -0.5, -2 ]
        Total Score: [ 25, 20, 15, 10 ]
        """

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        return label
    }()

    private lazy var explainLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white1
        let text = """
        Every number in brackets represent part of range that is used to determine score and recommendation. First number is the best and last number is the worst.

        Detailed breakdown of ranges:

        If value is higher than first number in brackets, the score will be 5 and recommendation would be "Strong Buy".
        If value is higher than second number and lower than first number, the score will be 4 and recommendation would be "Buy".
        If value is higher than third number and lower than second number, the score will be 3 and recommendation would be "Neutral".
        If value is higher than fourth number and lower than third number, the score will be 2 and recommendation would be "Sell".
        If value is lower than fourth number, the score will be 1 and recommendation would be "Strong Sell".
        """

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        return label
    }()

    private lazy var explainLabel3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white1
        let text = """
        To calculate main rating for stock we add scores of other individual values. Fields named "ratingScore" and "ratingRecommendation" are based on conditions above. Only difference is "rating" field.

        Conditions for "rating" are:

        If score is higher than 30, rating would be "S+"
        If score is higher than 28 and lower than 30, rating would be "S"
        If score is higher than 26 and lower than 28, rating would be "S-"
        If score is higher than 24 and lower than 26, rating would be "A+"
        If score is higher than 22 and lower than 24, rating would be "A-"
        If score is higher than 20 and lower than 22, rating would be "A-"
        If score is higher than 18 and lower than 20, rating would be "B+"
        If score is higher than 16 and lower than 18, rating would be "B"
        If score is higher than 14 and lower than 16, rating would be "B-"
        If score is higher than 12 and lower than 14, rating would be "C+"
        If score is higher than 10 and lower than 12, rating would be "C"
        If score is higher than 8 and lower than 10, rating would be "C-"
        If score is higher than 6 and lower than 8, rating would be "D+"
        If score is higher than 4 and lower than 6, rating would be "D"
        If score is higher than 2 and lower than 4, rating would be "D-
        """
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
        ]

        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
        return label
    }()

    lazy var referenceLabel = UITextView().then { textView in
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.dataDetectorTypes = .all
        textView.textContainer.lineFragmentPadding = .zero
        textView.textContainer.maximumNumberOfLines = 2
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.text = "https://financialmodelingprep.com/developer/docs/recommendations-formula"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Company Rating".localized()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.bounds.width)
        }

        containerView.addSubview(titleLabel1)
        containerView.addSubview(explainLabel1)
        containerView.addSubview(titleLabel2)
        containerView.addSubview(explainLabel2)
        containerView.addSubview(titleLabel3)
        containerView.addSubview(explainLabel3)
        containerView.addSubview(referenceLabel)

        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        explainLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(explainLabel1.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        explainLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        titleLabel3.snp.makeConstraints { make in
            make.top.equalTo(explainLabel2.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        explainLabel3.snp.makeConstraints { make in
            make.top.equalTo(titleLabel3.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        referenceLabel.snp.makeConstraints { make in
            make.top.equalTo(explainLabel3.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-80)
        }
    }
}
