//
//  StockDataDatesViewController.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/3.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Cache
import Hue
import Localize_Swift
import SnapKit
import Then
import UIKit

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
    import Schedule
#endif

protocol StockDataDatesViewControllerDelegate: AnyObject {
    func handleDateSelected(selectedIndex: Int)
}

class StockDataDatesViewController: FGUIViewController {
    weak var delegate: StockDataDatesViewControllerDelegate?
    #if !targetEnvironment(macCatalyst)
        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView()
            bannerView.adUnitID = Constants.GoogleAdsID.bannerViewAdUnitID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            return bannerView
        }()
    #endif

    enum DataType {
        case single
        case multiple
    }

    var dataType: DataType = .single
    var numberOfDatas: Int = 4

    var financialBase: FinancialBase?

    var currentIndex: Int = 0
    var financials = [Financial]()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 16, right: 20)

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(FiscalPeriodDateCell.self, forCellWithReuseIdentifier: "FiscalPeriodDateCell")
        collectionView.register(FiscalPeriodCompareCell.self, forCellWithReuseIdentifier: "FiscalPeriodCompareCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = 80

        return collectionView
    }()

    override var isStaticBackground: Bool {
        return true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Select a Date".localized()

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.top.bottom.equalToSuperview()
        }

        #if !targetEnvironment(macCatalyst)
            if RemoveAdsProduct.store.isProductPurchased(RemoveAdsProduct.removeAdsProductIdentifier) {
                print("Previously purchased: \(RemoveAdsProduct.removeAdsProductIdentifier)")
            } else {
                view.addSubview(bannerView)
                bannerView.snp.makeConstraints { make in
                    make.height.equalTo(50)
                    make.width.equalToSuperview()
                    make.bottom.equalTo(view.safeAreaLayoutGuide)
                    make.centerX.equalToSuperview()
                }
            }
        #endif
    }
}

extension StockDataDatesViewController {
    @objc func compareSwitchTapped(_ sender: UISwitch) {
        if let financialBase = financialBase {
            FiscalPeriodCompareHelper.setCompare(financialBase: financialBase, isCompare: sender.isOn)
            collectionView.reloadData()
            delegate?.handleDateSelected(selectedIndex: currentIndex)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension StockDataDatesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return financials.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiscalPeriodCompareCell", for: indexPath) as! FiscalPeriodCompareCell
            if let financialBase = financialBase {
                cell.compareSwitch.isOn = FiscalPeriodCompareHelper.getCompare(financialBase: financialBase)
            }
            cell.compareSwitch.addTarget(self, action: #selector(compareSwitchTapped(_:)), for: .valueChanged)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiscalPeriodDateCell", for: indexPath) as! FiscalPeriodDateCell
            let row = indexPath.row
            if currentIndex == row {
                cell.isCurrent = true
            } else {
                cell.isCurrent = false
            }

            if let financialBase = financialBase, currentIndex + numberOfDatas == row, FiscalPeriodCompareHelper.getCompare(financialBase: financialBase) {
                cell.isCompare = true
            } else {
                cell.isCompare = false
            }

            if dataType == .single {
                cell.isMultiple = false
            } else {
                cell.isMultiple = true
            }

            if row + numberOfDatas - 1 <= financials.count - 1 {
                cell.beginFinancial = financials[row + numberOfDatas - 1]
            } else {
                cell.beginFinancial = nil
            }
            cell.financial = financials[row]

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            ImpactManager.shared.generate()
            currentIndex = indexPath.row
            collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.delegate?.handleDateSelected(selectedIndex: indexPath.row)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension StockDataDatesViewController: UICollectionViewDelegateFlowLayout {
    // 定义每一个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.safeAreaLayoutGuide.layoutFrame.width
        if indexPath.section == 0 {
            return CGSize(width: viewWidth, height: 90)
        } else {
            if dataType == .single {
                if Constants.Device.isIphone {
                    let width = (viewWidth - 20 * 2 - 16 * 2) / 3 - 1
                    return CGSize(width: width, height: 40)
                } else {
                    return CGSize(width: 144, height: 40)
                }
            } else {
                if Constants.Device.isIphone {
                    return CGSize(width: viewWidth - 40, height: 40)
                } else {
                    return CGSize(width: 240, height: 40)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        }
        return UIEdgeInsets(top: 16, left: 20, bottom: 0, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return .zero
        }
        return CGFloat(16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return .zero
        }
        return CGFloat(16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}
