//
//  StockDataSingleCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Then
import UIKit

func createCompareAttribuateString(stockData: StockData, company: Company, previousStockData: StockData?) -> NSMutableAttributedString {
    guard let value = stockData.value else {
        return NSMutableAttributedString(attributedString: NSAttributedString(string: "No Data".localized()))
    }
    if stockData.dataType == .decimal || stockData.dataType == .original {
        let valueString: String
        if stockData.dataType == .decimal {
            valueString = value.convertToCurrency(localeIdentifier: company.localeIdentifier)
        } else {
            valueString = value.convertToVariableDigitsDecimal()
        }

        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: valueString, attributes: [NSAttributedString.Key.paragraphStyle: createParagraphStyle()]))

        let previousValue = previousStockData?.value ?? 0
        let changes: Double = value - previousValue
        let changePercent: Double = changes / value * 100
        let changesString = changes >= 0 ? "+" + changes.decimalTwoDigitsString : changes.decimalTwoDigitsString
        let changePercentString = changes >= 0 ? "(↑" + convertDoubleToDecimal(amount: changePercent) + "%)" : "(↓" + convertDoubleToDecimal(amount: fabs(changePercent)) + "%)"
        let changesStringAll = value != 0 ? changesString + " " + changePercentString : changesString
        let numberOfDecimals = log10(fabs(value) + 1) + log10(fabs(changes) + 1) + log10(fabs(changePercent) + 1)
        attributedString.append(NSAttributedString(
            string: (numberOfDecimals > 14 && Constants.Device.isIphone) ? "\n" + changesStringAll : "  " + changesStringAll,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                NSAttributedString.Key.foregroundColor: changes >= 0 ? UIColor.increaseNumberGreen : UIColor.decreaseNumberRed]))
        return attributedString
    } else {
        let ratioValue = value * 100
        let valueString = ratioValue.decimalTwoDigitsString + "%"
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: valueString, attributes: [NSAttributedString.Key.paragraphStyle: createParagraphStyle()]))

        let previousValue = (previousStockData?.value ?? 0) * 100
        let changes: Double = ratioValue - previousValue
        let changePercent: Double = ratioValue == 0 ? 0 : changes / ratioValue * 100
        let changesString = changes >= 0 ? "+" + changes.decimalTwoDigitsString + "%" : changes.decimalTwoDigitsString + "%"
        let changePercentString = changes >= 0 ? "(↑" + convertDoubleToDecimal(amount: changePercent) + "%)" : "(↓" + convertDoubleToDecimal(amount: fabs(changePercent)) + "%)"
        let changesStringAll = ratioValue != 0 ? changesString + " " + changePercentString : changesString
        attributedString.append(NSAttributedString(
            string: "  " + changesStringAll,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.paragraphStyle: createParagraphStyle(),
                NSAttributedString.Key.foregroundColor: changes >= 0 ? UIColor.increaseNumberGreen : UIColor.decreaseNumberRed]))
        return attributedString
    }
}

class StockDataSingleCell: UITableViewCell {
    var company: Company?

    var compare: Bool = true
    var previousStockData: StockData?
    var stockData: StockData? {
        didSet {
            guard let stockData = stockData, let company = company else { return }

            stockDataNameLabel.text = stockData.name
            stockDataValueLabel.attributedText = nil
            stockDataValueLabel.text = ""
            if let value = stockData.value {
                if compare {
                    stockDataValueLabel.attributedText = createCompareAttribuateString(stockData: stockData, company: company, previousStockData: previousStockData)
                } else {
                    if stockData.dataType == .decimal {
                        stockDataValueLabel.text = value.convertToCurrency(localeIdentifier: company.localeIdentifier)
                    } else if stockData.dataType == .original {
                        stockDataValueLabel.text = value.convertToVariableDigitsDecimal()
                    } else {
                        stockDataValueLabel.text = (value * 100).decimalTwoDigitsString + "%"
                    }
                }
            } else {
                stockDataValueLabel.text = "No Data".localized()
            }

            if stockData.financialTerm != nil {
                infoButton.isHidden = false
            } else {
                infoButton.isHidden = true
            }
        }
    }

    lazy var stockDataView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
    }

    lazy var stockDataNameLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 15)
    }

    lazy var stockDataValueLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.title
    }

    lazy var infoButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .systemGray
        b.addTarget(self, action: #selector(infoTapped(_:)), for: .touchUpInside)
        b.contentHorizontalAlignment = .left
        b.contentMode = .scaleAspectFit
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(stockDataView)
        stockDataView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        stockDataView.layer.shadowColor = UIColor.black1.cgColor
        stockDataView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stockDataView.layer.shadowRadius = 8
        stockDataView.layer.shadowOpacity = 1

        stockDataView.addSubview(stockDataNameLabel)
        stockDataView.addSubview(stockDataValueLabel)
        stockDataView.addSubview(infoButton)

        stockDataNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().offset(-12 - 24 - 12)
            make.top.equalTo(stockDataView).inset(12)
        }

        stockDataValueLabel.snp.makeConstraints { make in
            make.top.equalTo(stockDataNameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(-12 - 24 - 12)
            make.bottom.equalToSuperview().inset(12)
        }

        infoButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        infoButton.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StockDataSingleCell {
    @objc func infoTapped(_ sender: UIButton) {
        let financialDefinitionViewController = FinancialDefinitionViewController()
        financialDefinitionViewController.financialTerm = stockData?.financialTerm
        parentViewController?.navigationController?.pushViewController(financialDefinitionViewController, animated: true)
    }
}
