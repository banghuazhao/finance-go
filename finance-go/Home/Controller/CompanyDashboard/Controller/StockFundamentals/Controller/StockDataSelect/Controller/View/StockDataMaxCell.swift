//
//  StockDataMaxCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Charts
import Then
import UIKit

class StockDataMaxCell: UITableViewCell {
    var company: Company?

    var financials: [Financial]?
    var stockDatas: [StockData]? {
        didSet {
            guard var stockDatas = stockDatas, var financials = financials, let company = company, stockDatas.count > 0 else { return }

            let dataType = stockDatas[0].dataType
            stockDatas.reverse()
            financials.reverse()

            stockDataNameLabel.text = stockDatas[0].name

            if stockDatas.first?.financialTerm != nil {
                infoButton.isHidden = false
            } else {
                infoButton.isHidden = true
            }

            var entries = [ChartDataEntry]()

            for (i, stockData) in stockDatas.enumerated() {
                if let value = stockData.value {
                    let x: Double = Double(i)
                    let y: Double = dataType == .ratio ? value * 100 : value
                    let date = financials[i].date
                    entries.append(ChartDataEntry(x: x, y: y, data: date))
                }
            }

            if let lastEntry = entries.last {
                dateLabel.text = lastEntry.data as? String ?? ""
                if dataType == .decimal {
                    stockDataValueLabel.text = lastEntry.y.convertToCurrency(localeIdentifier: company.localeIdentifier)
                } else if dataType == .original {
                    stockDataValueLabel.text = lastEntry.y.convertToVariableDigitsDecimal()
                } else {
                    stockDataValueLabel.text = lastEntry.y.decimalTwoDigitsString + "%"
                }
            }

            let set = FinancialLineChartDataSet(entries: entries)

            let data = LineChartData(dataSet: set)

            data.setDrawValues(false)

            lineChartView.xAxis.axisMaximum = Double(stockDatas.count - 1)

            let financialYAxisValueFormatter = FinancialYAxisValueFormatter()
            financialYAxisValueFormatter.dataType = dataType
            financialYAxisValueFormatter.localeIdentifier = company.localeIdentifier

            lineChartView.rightAxis.valueFormatter = financialYAxisValueFormatter

            let financialXAxisValueFormatter = FinancialXAxisValueFormatter()
            financialXAxisValueFormatter.entries = entries
            lineChartView.xAxis.valueFormatter = financialXAxisValueFormatter

            lineChartView.highlightValue(x: 0, dataSetIndex: -1)
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

extension StockDataMaxCell {
    @objc func infoTapped(_ sender: UIButton) {
        let financialDefinitionViewController = FinancialDefinitionViewController()
        financialDefinitionViewController.financialTerm = stockDatas?.first?.financialTerm
        parentViewController?.navigationController?.pushViewController(financialDefinitionViewController, animated: true)
    }

    @objc func share(_ sender: UIButton) {
        guard let stockDatas = stockDatas, let company = company, stockDatas.count > 0 else { return }
        contentView.asyncTakeSnapshotOfFullContent { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                let textToShare = stockDatas[0].name + " " + company.symbol
                let objectsToShare = [textToShare, image] as [Any]
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

extension StockDataMaxCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let stockDatas = stockDatas, let company = company else { return }

        ImpactManager.shared.generate()

        dateLabel.text = entry.data as? String ?? ""
        if stockDatas[0].dataType == .decimal {
            stockDataValueLabel.text = entry.y.convertToCurrency(localeIdentifier: company.localeIdentifier)
        } else if stockDatas[0].dataType == .original {
            stockDataValueLabel.text = entry.y.convertToVariableDigitsDecimal()
        } else {
            stockDataValueLabel.text = entry.y.decimalTwoDigitsString + "%"
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        guard let chartView = chartView as? FinancialLineChartView, let stockDatas = stockDatas, let company = company else { return }
        if let dataSet = chartView.lineData?.dataSets[0], let entry = dataSet.entryForIndex(dataSet.entryCount - 1) {
            dateLabel.text = entry.data as? String ?? ""
            if stockDatas[0].dataType == .decimal {
                stockDataValueLabel.text = entry.y.convertToCurrency(localeIdentifier: company.localeIdentifier)
            } else if stockDatas[0].dataType == .original {
                stockDataValueLabel.text = entry.y.convertToVariableDigitsDecimal()
            } else {
                stockDataValueLabel.text = entry.y.decimalTwoDigitsString + "%"
            }
        }
    }
}
