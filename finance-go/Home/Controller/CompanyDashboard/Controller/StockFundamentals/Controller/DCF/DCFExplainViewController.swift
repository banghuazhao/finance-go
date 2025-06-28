//
//  DCFExplainViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/27.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif

class DCFExplainViewController: FGUIViewController {
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
        label.text = "DCF calculation:"
    }

    private lazy var explainLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white1

        let text = """
        
        Market Cap = Weigted Average Shares Outstanding Diluted * Stock Price

        Enterprise Value NB = Market Cap + Long Term Debt + Short Term Debt

        Equity Value = Enterprise Value NB - Net Debt

        DCF = Equity Value / Weigted Average Shares Outstanding Diluted

        Stock Beta = Monthly price change of stock relative to the monthly price change of the S&P500 (COV(Rs,RM) / VAR(Rm))
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
        textView.text = "https://financialmodelingprep.com/developer/docs/dcf-formula"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Discounted Cash Flow".localized()

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
        containerView.addSubview(referenceLabel)

        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        explainLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        referenceLabel.snp.makeConstraints { make in
            make.top.equalTo(explainLabel1.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-80)
        }
    }
}
