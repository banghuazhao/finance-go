//
//  FGUIViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 1/12/21.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import UIKit

class FGUIViewController: UIViewController {
    var isStaticBackground: Bool {
        return true
    }

    lazy var loadingView = LoadingView()
    lazy var noDataView = NoDataView()
    lazy var networkErrorView = NetworkErrorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.sublayers?.removeFirst()
        setGradientBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for view in view.subviews where view is UIScrollView && view.isHidden == false {
            if let navController = navigationController as? FGUINavigationController, let scrollView = view as? UIScrollView {
                if !isStaticBackground {
                    DispatchQueue.main.async {
                        if scrollView.contentOffset.y > -scrollView.adjustedContentInset.top {
                            navController.setBackground(color: .navBarColor)
                        } else {
                            navController.setBackground(color: .clear)
                        }
                    }
                } else {
                    navController.setBackground(color: .navBarColor)
                }
            }
        }
    }
}

// MARK: - methods

extension FGUIViewController {
    func initStateViews() {
        view.addSubview(loadingView)
        view.addSubview(noDataView)
        view.addSubview(networkErrorView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noDataView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        networkErrorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingView.isHidden = true
        noDataView.isHidden = true
        networkErrorView.isHidden = true
    }
    
    func startLoading() {
        loadingView.isHidden = false
        noDataView.isHidden = true
        networkErrorView.isHidden = true
    }
    
    func endLoading() {
        loadingView.isHidden = true
        noDataView.isHidden = true
        networkErrorView.isHidden = true
    }

    func startFetchData() {
        loadingView.isHidden = true
        noDataView.isHidden = true
        networkErrorView.isHidden = true
    }

    func showNoData() {
        loadingView.isHidden = true
        noDataView.isHidden = false
        networkErrorView.isHidden = true
    }

    func showNetworkError() {
        loadingView.isHidden = true
        noDataView.isHidden = true
        networkErrorView.isHidden = false
    }
}

extension FGUIViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if let navController = navigationController as? FGUINavigationController {
            if !isStaticBackground {
                DispatchQueue.main.async {
                    if scrollView.contentOffset.y > -scrollView.adjustedContentInset.top {
                        navController.setBackground(color: .navBarColor)
                    } else {
                        navController.setBackground(color: .clear)
                    }
                }
            } else {
                return
            }
        }
    }
}

// MARK: - LoadingView

class LoadingView: UIView {
    lazy var activityIndicator = UIActivityIndicatorView().then { indicator in
        if #available(iOS 13.0, *) {
            indicator.style = .large
            indicator.color = .white
        } else {
            indicator.style = .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - NoDataView

class NoDataView: UIView {
    lazy var noDataImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "no_data")
        imageView.contentMode = .scaleAspectFit
    }

    lazy var noDataLabel = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.textAlignment = .center
        label.text = "No Data".localized()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addSubview(noDataImageView)
        addSubview(noDataLabel)
        noDataImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.size.equalTo(200)
        }
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noDataImageView.snp.bottom)
        }
    }
}

// MARK: - NetworkErrorView

class NetworkErrorView: UIView {
    lazy var networkErrorImageView = UIImageView().then { imageView in
        imageView.image = UIImage(named: "network_error")
        imageView.contentMode = .scaleAspectFit
    }

    lazy var networkErrorLabel = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.textAlignment = .center
        label.text = "Network Error".localized()
    }

    lazy var pullToReloadLabel = UILabel().then { label in
        label.font = UIFont.bigTitle
        label.textColor = .white1
        label.textAlignment = .center
        label.text = "Pull to Reload".localized()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        addSubview(networkErrorImageView)
        addSubview(networkErrorLabel)
        addSubview(pullToReloadLabel)
        networkErrorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
            make.size.equalTo(200)
        }
        networkErrorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(networkErrorImageView.snp.bottom).offset(30)
        }
        pullToReloadLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(networkErrorLabel.snp.bottom).offset(20)
        }
    }
}
