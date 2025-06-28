//
//  StockDataMultipleCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Charts
import Then
import UIKit

class StockDataMultipleCell: UITableViewCell {
    var company: Company?

    var compare: Bool = true

    var numberOfDatas: Int = 4

    var previousFinancials: [Financial?]?
    var currentFinancials: [Financial?]?

    var previousStockDatas: [StockData?]?

    var stockDatas: [StockData?]? {
        didSet {
            guard var stockDatas = stockDatas,
                  var previousStockDatas = previousStockDatas,
                  var currentFinancials = currentFinancials,
                  var previousFinancials = previousFinancials,
                  let company = company, stockDatas.count > 0,
                  let firstStockData = stockDatas[0] else { return }

            stockDatas.reverse()
            previousStockDatas.reverse()
            currentFinancials.reverse()
            previousFinancials.reverse()

            let dataType = firstStockData.dataType

            stockDataNameLabel.text = firstStockData.name

            if firstStockData.financialTerm != nil {
                infoButton.isHidden = false
            } else {
                infoButton.isHidden = true
            }

            var entries = [ChartDataEntry]()

            for (i, stockData) in stockDatas.enumerated() {
                if let value = stockData?.value, let date = currentFinancials[i]?.date {
                    let x: Double = Double(i)
                    let y: Double = dataType == .ratio ? value * 100 : value
                    entries.append(ChartDataEntry(x: x, y: y, data: date))
                }
            }

            let currentDate = currentFinancials[numberOfDatas - 1]?.date ?? "-"
            let previousDate = previousFinancials[numberOfDatas - 1]?.date ?? "-"
            if compare {
                let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: currentDate))
                attributedString.append(NSAttributedString(
                    string: " " + "vs".localized() + " " + previousDate,
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
                dateLabel.attributedText = attributedString
            } else {
                dateLabel.text = currentDate
            }

            if let value = firstStockData.value {
                if compare {
                    stockDataValueLabel.attributedText = createCompareAttribuateString(stockData: firstStockData, company: company, previousStockData: previousStockDatas[numberOfDatas - 1])
                } else {
                    if dataType == .decimal {
                        stockDataValueLabel.text = value.convertToCurrency(localeIdentifier: company.localeIdentifier)
                    } else if dataType == .original {
                        stockDataValueLabel.text = value.convertToVariableDigitsDecimal()
                    } else {
                        stockDataValueLabel.text = (value * 100).decimalTwoDigitsString + "%"
                    }
                }
            } else {
                stockDataValueLabel.text = "No Data".localized()
            }

            let set = FinancialLineChartDataSet(entries: entries)

            let data = LineChartData(dataSet: set)

            if compare {
                var entries2 = [ChartDataEntry]()

                for (i, stockData) in previousStockDatas.enumerated() {
                    if let value = stockData?.value, let date = currentFinancials[i]?.date {
                        let x: Double = Double(i)
                        let y: Double = dataType == .ratio ? value * 100 : value
                        entries2.append(ChartDataEntry(x: x, y: y, data: date))
                    }
                }
                let set2 = FinancialLineChartDataSet(entries: entries2)
                set2.lineDashLengths = [4, 2]
                data.addDataSet(set2)
            }

            lineChartView.xAxis.axisMaximum = Double(numberOfDatas - 1)

            let financialYAxisValueFormatter = FinancialYAxisValueFormatter()
            financialYAxisValueFormatter.dataType = dataType
            financialYAxisValueFormatter.localeIdentifier = company.localeIdentifier

            lineChartView.rightAxis.valueFormatter = financialYAxisValueFormatter

            let financialXAxisValueFormatter = FinancialXAxisValueFormatter()
            financialXAxisValueFormatter.entries = entries
            lineChartView.xAxis.valueFormatter = financialXAxisValueFormatter

            lineChartView.highlightValue(x: 0, dataSetIndex: -1)

            data.setDrawValues(false)

            lineChartView.data = data

            lineChartView.notifyDataSetChanged()
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

    lazy var lineChartView = FinancialLineChartView(frame: .zero).then { cv in
        cv.delegate = self
    }

    lazy var dateLabel = UILabel().then { label in
        label.numberOfLines = 1
        label.textColor = UIColor.black1
        label.font = UIFont.systemFont(ofSize: 14)
    }

    lazy var infoButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .systemGray
        b.addTarget(self, action: #selector(infoTapped(_:)), for: .touchUpInside)
        b.contentHorizontalAlignment = .left
        b.contentMode = .scaleAspectFit
    }

    lazy var shareButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "navItem_share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .systemGray
        b.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
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

        stockDataView.addSubview(stockDataNameLabel)
        stockDataView.addSubview(stockDataValueLabel)
        stockDataView.addSubview(infoButton)
        stockDataView.addSubview(shareButton)
        stockDataView.addSubview(lineChartView)
        stockDataView.addSubview(dateLabel)

        stockDataNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().offset(-12 - 24 - 12)
            make.top.equalTo(stockDataView).inset(12)
        }

        stockDataValueLabel.snp.makeConstraints { make in
            make.top.equalTo(stockDataNameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(-12 - 24 - 12)
        }

        infoButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalTo(stockDataNameLabel)
            make.size.equalTo(24)
        }

        infoButton.isHidden = true

        shareButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.top.equalTo(infoButton.snp.bottom).offset(12)
            make.size.equalTo(24)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(stockDataValueLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
        }

        lineChartView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            make.height.equalTo(220)
            make.top.equalTo(dateLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension StockDataMultipleCell {
    @objc func infoTapped(_ sender: UIButton) {
        guard let stockDatas = stockDatas, stockDatas.count > 0, let firstStockData = stockDatas[0] else { return }
        let financialDefinitionViewController = FinancialDefinitionViewController()
        financialDefinitionViewController.financialTerm = firstStockData.financialTerm
        parentViewController?.navigationController?.pushViewController(financialDefinitionViewController, animated: true)
    }

    @objc func share(_ sender: UIButton) {
        guard let stockDatas = stockDatas, let company = company, stockDatas.count > 0, let firstStockData = stockDatas[0] else { return }
        contentView.asyncTakeSnapshotOfFullContent { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                let textToShare = firstStockData.name + " " + company.symbol
                let objectsToShare = [image, textToShare] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                if let popoverController = activityVC.popoverPresentationController {
                    popoverController.sourceRect = sender.bounds
                    popoverController.sourceView = sender
                }
                self.parentViewController?.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - ChartViewDelegate

extension StockDataMultipleCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard var stockDatas = stockDatas,
              var previousStockDatas = previousStockDatas,
              var currentFinancials = currentFinancials,
              var previousFinancials = previousFinancials,
              let company = company else { return }

        ImpactManager.shared.generate()

        let index = Int(entry.x)
        stockDatas.reverse()
        previousStockDatas.reverse()
        currentFinancials.reverse()
        previousFinancials.reverse()

        if let stockData = stockDatas[index] {
            if compare {
                stockDataValueLabel.attributedText = createCompareAttribuateString(stockData: stockData, company: company, previousStockData: previousStockDatas[index])
            } else {
                if stockData.dataType == .decimal {
                    stockDataValueLabel.text = entry.y.convertToCurrency(localeIdentifier: company.localeIdentifier)
                } else if stockData.dataType == .original {
                    stockDataValueLabel.text = entry.y.convertToVariableDigitsDecimal()
                } else {
                    stockDataValueLabel.text = entry.y.decimalTwoDigitsString + "%"
                }
            }
        } else {
            stockDataValueLabel.text = "No Data".localized()
        }

        let currentDate = currentFinancials[index]?.date ?? "-"
        let previousDate = previousFinancials[index]?.date ?? "-"
        if compare {
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: currentDate))
            attributedString.append(NSAttributedString(
                string: " " + "vs".localized() + " " + previousDate,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            dateLabel.attributedText = attributedString
        } else {
            dateLabel.text = currentDate
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        guard let stockDatas = stockDatas,
              let previousStockDatas = previousStockDatas,
              let company = company else { return }

        if let stockData = stockDatas[0], let value = stockData.value {
            if compare {
                stockDataValueLabel.attributedText = createCompareAttribuateString(stockData: stockData, company: company, previousStockData: previousStockDatas[0])
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

        let currentDate = currentFinancials?[0]?.date ?? "-"
        let previousDate = previousFinancials?[0]?.date ?? "-"
        if compare {
            let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: currentDate))
            attributedString.append(NSAttributedString(
                string: " " + "vs".localized() + " " + previousDate,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
            dateLabel.attributedText = attributedString
        } else {
            dateLabel.text = currentDate
        }
    }
}
