//
//  StockChartPriceCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/16.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Charts
import UIKit

class StockChartPriceCell: UITableViewCell {
    var company: Company? {
        didSet {
            guard let company = company else { return }

            companySymbolLabel.text = company.symbol
            typeLabel.text = "  " + company.type.rawValue.localized() + "  "
            companyNameLabel.text = company.name
            likeButton.tintColor = company.isWatched ? UIColor.orange1 : UIColor.systemGray

            guard let companyQuote = company.companyQuote else { return }

            if let price = companyQuote.price {
                setPriceLabel(price: price, localeIdentifier: company.localeIdentifier)
                rightArrowButton.isHidden = false
            } else {
                rightArrowButton.isHidden = true
            }

            setUnselectedChangeAndLine(stockChartView: stockChartViews[segmentedControl.selectedSegmentIndex])
        }
    }

    var oneDayStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != oneDayStockPrices {
                drawStockChartView(stockPrices: oneDayStockPrices, stockChartView: oneDayStockChartView)
            }
        }
    }

    var oneWeekStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != oneWeekStockPrices {
                drawStockChartView(stockPrices: oneWeekStockPrices, stockChartView: oneWeekStockChartView)
            }
        }
    }

    var oneMonthStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != oneMonthStockPrices {
                drawStockChartView(stockPrices: oneMonthStockPrices, stockChartView: oneMonthStockChartView)
            }
        }
    }

    var threeMonthStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != threeMonthStockPrices {
                drawStockChartView(stockPrices: threeMonthStockPrices, stockChartView: threeMonthStockChartView)
            }
        }
    }

    var oneYearStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != oneYearStockPrices {
                drawStockChartView(stockPrices: oneYearStockPrices, stockChartView: oneYearStockChartView)
            }
        }
    }

    var fiveYearStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != fiveYearStockPrices {
                drawStockChartView(stockPrices: fiveYearStockPrices, stockChartView: fiveYearStockChartView)
            }
        }
    }

    var maxStockPrices: [StockChartPrice]? {
        didSet {
            if oldValue != maxStockPrices {
                drawStockChartView(stockPrices: maxStockPrices, stockChartView: maxStockChartView)
            }
        }
    }

    lazy var companySymbolLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.font = UIFont.boldSystemFont(ofSize: 28)
    }

    lazy var typeLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.backgroundColor = UIColor.white3
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 16)
    }

    lazy var companyNameLabel = UILabel().then { label in
        label.textColor = UIColor.white1
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
    }

    lazy var likeButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "icon_star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(self, action: #selector(likeAction(_:)), for: .touchUpInside)
        b.tintColor = .systemGray
    }

    lazy var priceLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white1
        label.font = UIFont.boldSystemFont(ofSize: 32)
    }

    lazy var changeLabel = UILabel().then { label in
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = UIColor.white1
    }

    lazy var oneDayStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var oneWeekStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var oneMonthStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var threeMonthStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var oneYearStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var fiveYearStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    lazy var maxStockChartView = StockLineChartView(frame: .zero).then { cv in
        cv.delegate = self
        if let gestureRecognizers = cv.gestureRecognizers {
            for recognizer in gestureRecognizers {
                recognizer.addTarget(self, action: #selector(self.cancelLineSelect(_:)))
            }
        }
    }

    var stockChartViews = [StockLineChartView]()

    lazy var segmentedControl = UISegmentedControl(items: ["1D", "1W", "1M", "3M", "1Y", "5Y", "Max"]).then { s in
        s.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.increaseGreen, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
        s.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black1, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        s.selectedSegmentIndex = 0
        s.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            s.selectedSegmentTintColor = .increaseGreen
        } else {
            s.tintColor = .increaseGreen
        }
        s.sizeToFit()
        s.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    lazy var rightArrowButton = UIButtonLargerTouchArea(type: .custom).then { b in
        b.setImage(UIImage(named: "button_right_arrow_circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.addTarget(self, action: #selector(showStockQuote), for: .touchUpInside)
        b.tintColor = .white1
    }

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        stockChartViews = [oneDayStockChartView, oneWeekStockChartView, oneMonthStockChartView, threeMonthStockChartView, oneYearStockChartView, fiveYearStockChartView, maxStockChartView]

        contentView.addSubview(companySymbolLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(likeButton)

        contentView.addSubview(priceLabel)
        contentView.addSubview(rightArrowButton)
        contentView.addSubview(changeLabel)

        for chartView in stockChartViews {
            contentView.addSubview(chartView)
        }
        contentView.addSubview(segmentedControl)

        companySymbolLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().inset(20)
        }

        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(companySymbolLabel.snp.right).offset(12)
            make.height.equalTo(24)
            make.centerY.equalTo(companySymbolLabel)
        }

        companyNameLabel.snp.makeConstraints { make in
            make.top.equalTo(companySymbolLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(companySymbolLabel)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(companyNameLabel.snp.bottom).offset(8)
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(20)
        }

        rightArrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.height.equalTo(24)
            make.right.equalToSuperview().offset(-20)
        }
        rightArrowButton.isHidden = true

        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.height.equalTo(30)
            make.left.right.equalToSuperview().inset(20)
        }

        for chartView in stockChartViews {
            chartView.snp.makeConstraints { make in
                make.top.equalTo(changeLabel.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(240)
            }
        }

        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(oneDayStockChartView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-10)
        }

        showChartView(index: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension StockChartPriceCell {
    @objc private func cancelLineSelect(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .ended {
            ImpactManager.shared.generate()
            let selectedIndex = segmentedControl.selectedSegmentIndex
            stockChartViews[selectedIndex].unHighlightValue()
        }
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        ImpactManager.shared.generate()
        let selectedIndex = sender.selectedSegmentIndex
        showChartView(index: selectedIndex)
    }

    @objc func showStockQuote() {
        let stockQuotesViewController = StockQuotesViewController()
        stockQuotesViewController.company = company
        parentViewController?.navigationController?.pushViewController(stockQuotesViewController, animated: true)
    }

    @objc func likeAction(_ sender: UIButton) {
        guard let company = company else { return }
        if !company.isWatched {
            ImpactManager.shared.generate()
            sender.tintColor = UIColor.orange1
            WatchCompanyHelper.appendWatchCompanySymbol(company: company)
            parentViewController?.view.makeToast("Watchlist added".localized() + " " + company.symbol, duration: 1.0)
            NotificationCenter.default.post(name: .didAddWatchCompany, object: company)
        } else {
            ImpactManager.shared.generate()
            sender.tintColor = UIColor.systemGray
            WatchCompanyHelper.removeWatchCompanySymbol(company: company)
            parentViewController?.view.makeToast("Watch list removed".localized() + " " + company.symbol, duration: 1.0)
            NotificationCenter.default.post(name: .didRemoveWatchCompany, object: company)
        }
    }
}

// MARK: - methods

extension StockChartPriceCell {
    func showChartView(index: Int) {
        for (i, chartView) in stockChartViews.enumerated() {
            if i == index {
                chartView.isHidden = false
                setUnselectedChangeAndLine(stockChartView: chartView)
            } else {
                chartView.isHidden = true
            }
        }
    }

    func setPriceLabel(price: Double, localeIdentifier: String = "en_US") {
        if let company = company, company.type != .index, company.type != .forex {
            priceLabel.text = price.convertToCurrency(localeIdentifier: localeIdentifier)
        } else {
            priceLabel.text = price.decimalTwoDigitsString
        }
    }

    func setUnselectedChangeLabel(change: Double, changePercent: Double, rangeString: String?) {
        guard let company = company else { return }
        let changeValueString = (company.type != .index && company.type != .forex) ? change.convertToCurrency(localeIdentifier: company.localeIdentifier) : change.decimalTwoDigitsString
        var changeString = (change >= 0 ? "▲ " : "▼ ") + changeValueString
        changeString += " (" + String(format: "%.2f%%", changePercent) + ")"
        let changeAttribuateString = NSAttributedString(
            string: changeString,
            attributes:
            [NSAttributedString.Key.foregroundColor: change >= 0 ? UIColor.increaseGreen : UIColor.decreaseRed,
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let change = NSMutableAttributedString(attributedString: changeAttribuateString)

        if let rangeString = rangeString {
            let dateString = " " + rangeString
            let dateAttribuateString = NSAttributedString(
                string: dateString,
                attributes:
                [NSAttributedString.Key.foregroundColor: UIColor.white1,
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            change.append(dateAttribuateString)
        }
        changeLabel.attributedText = change
    }

    func setSelectedChangeLabel(change: Double, changePercent: Double) {
        guard let company = company else { return }
        let changeValueString = (company.type != .index && company.type != .forex) ? change.convertToCurrency(localeIdentifier: company.localeIdentifier) : change.decimalTwoDigitsString
        var changeString = (change >= 0 ? "▲ " : "▼ ") + changeValueString
        changeString += " (" + String(format: "%.2f%%", changePercent) + ")"
        let changeAttribuateString = NSAttributedString(
            string: changeString,
            attributes:
            [NSAttributedString.Key.foregroundColor: change >= 0 ? UIColor.increaseGreen : UIColor.decreaseRed,
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        changeLabel.attributedText = changeAttribuateString
    }

    func setChartViewLineColor(chartView: StockLineChartView, change: Double) {
        if change >= 0 {
            chartView.lineData?.dataSets.first?.setColor(UIColor.increaseGreen)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.increaseGreen, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
            if #available(iOS 13.0, *) {
                segmentedControl.selectedSegmentTintColor = .increaseGreen
            } else {
                segmentedControl.tintColor = .increaseGreen
            }
        } else {
            chartView.lineData?.dataSets.first?.setColor(UIColor.decreaseRed)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.decreaseRed, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
            if #available(iOS 13.0, *) {
                segmentedControl.selectedSegmentTintColor = .decreaseRed
            } else {
                segmentedControl.tintColor = .decreaseRed
            }
        }
        chartView.notifyDataSetChanged()
    }

    // MARK: - drawStockChartView

    func drawStockChartView(stockPrices: [StockChartPrice]?, stockChartView: StockLineChartView) {
        guard let stockPrices = stockPrices else { return }

        DispatchQueue.global(qos: .userInteractive).async {
            var entries = [ChartDataEntry]()

            let firstDate = stockPrices.count > 0 ? Date.convertStringyyyyMMddHHmmssToDate(string: stockPrices[0].date) ?? Date() : Date()
            for (i, stockPrice) in stockPrices.enumerated() {
                let dateString: String
                var x: Double = 0
                if stockChartView == self.oneDayStockChartView {
                    let date = Date.convertStringyyyyMMddHHmmssToDate(string: stockPrice.date)
                    dateString = date?.stringTimeHHmm ?? stockPrice.date
                    let minuteDiff = (date ?? Date()).minutes(from: firstDate)

                    x = Double(minuteDiff / 5) > Double(i) ? Double(minuteDiff / 5) : Double(i)
                    print("minuteDiff: \(minuteDiff),  x: \(x)")
                } else if stockChartView == self.oneWeekStockChartView {
                    let date = Date.convertStringyyyyMMddHHmmssToDate(string: stockPrice.date)
                    dateString = date?.stringDayTimeMMddHHmm ?? stockPrice.date
                    x = Double(i)
                } else {
                    let date = Date.convertStringyyyyMMddToDate(string: stockPrice.date)
                    dateString = date?.stringDayyyyyMMdd ?? stockPrice.date
                    x = Double(i)
                }

                entries.append(ChartDataEntry(x: x, y: stockPrice.close, data: dateString))
            }

            let set = StockLineChartDataSet(entries: entries)

            let data = LineChartData(dataSet: set)

            if stockChartView == self.oneDayStockChartView, let previousClose = self.company?.companyQuote?.previousClose, let count = self.oneDayStockPrices?.count, count > 0, let company = self.company, [ValueType.stock, ValueType.fund, ValueType.etf, .index].contains(company.type) {
                var entries2 = [ChartDataEntry]()
                for i in 0 ... 78 {
                    entries2.append(ChartDataEntry(x: Double(i), y: previousClose))
                }
                let set2 = StockLineChartDataSet(entries: entries2)
                set2.setColor(.white2)
                set2.lineDashLengths = [2, 3]
                set2.highlightEnabled = false
                data.addDataSet(set2)
            }

            data.setDrawValues(false)

            stockChartView.xAxis.axisMinimum = 0

            if stockChartView == self.oneDayStockChartView {
                if let company = self.company, [ValueType.cryptocurrency, .future, .forex].contains(company.type) {
                    stockChartView.xAxis.axisMaximum = 278
                } else {
                    stockChartView.xAxis.axisMaximum = 78
                }
            } else {
                stockChartView.xAxis.axisMaximum = Double(stockPrices.count - 1)
            }

            DispatchQueue.main.async {
                stockChartView.data = data
                self.setUnselectedChangeAndLine(stockChartView: stockChartView)
            }
        }
    }

    func setUnselectedChangeAndLine(stockChartView: StockLineChartView) {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        changeLabel.attributedText = nil
        switch selectedIndex {
        case 0:
            if let change = company?.companyQuote?.change, let changePercent = company?.companyQuote?.changesPercentage {
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Today".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            } else {
                if let openValue = oneDayStockPrices?.first?.close, let lastValue = oneDayStockPrices?.last?.close {
                    let change = lastValue - openValue
                    let changePercent = change / openValue * 100
                    setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Today".localized())
                    setChartViewLineColor(chartView: stockChartView, change: change)
                }
            }
        case 1:
            if let openValue = oneWeekStockPrices?.first?.close, let lastValue = oneWeekStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Past Week".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        case 2:
            if let openValue = oneMonthStockPrices?.first?.close, let lastValue = oneMonthStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Past Month".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        case 3:
            if let openValue = threeMonthStockPrices?.first?.close, let lastValue = threeMonthStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Past 3 Months".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        case 4:
            if let openValue = oneYearStockPrices?.first?.close, let lastValue = oneYearStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Past Year".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        case 5:
            if let openValue = fiveYearStockPrices?.first?.close, let lastValue = fiveYearStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "Past 5 Years".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        case 6:
            if let openValue = maxStockPrices?.first?.close, let lastValue = maxStockPrices?.last?.close {
                let change = lastValue - openValue
                let changePercent = change / openValue * 100
                setUnselectedChangeLabel(change: change, changePercent: changePercent, rangeString: "All Time".localized())
                setChartViewLineColor(chartView: stockChartView, change: change)
            }
        default:
            return
        }
    }
}

// MARK: - ChartViewDelegate

extension StockChartPriceCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let parentViewController = parentViewController as? CompanyDashboardViewController {
            for view in parentViewController.view.subviews where view is UIScrollView && view.isHidden == false {
                (view as? UIScrollView)?.isScrollEnabled = false
            }
            parentViewController.isSelectingStockLine = true
        }

        let y = entry.y
        if let localeIdentifier = company?.localeIdentifier {
            setPriceLabel(price: y, localeIdentifier: localeIdentifier)
        } else {
            setPriceLabel(price: y)
        }

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let previousClose = company?.companyQuote?.previousClose {
                let change = y - previousClose
                let changePercent = change / previousClose * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            } else if let openValue = oneDayStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 1:
            if let openValue = oneWeekStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 2:
            if let openValue = oneMonthStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 3:
            if let openValue = threeMonthStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 4:
            if let openValue = oneYearStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 5:
            if let openValue = fiveYearStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        case 6:
            if let openValue = maxStockPrices?.first?.close {
                let change = y - openValue
                let changePercent = change / openValue * 100
                setSelectedChangeLabel(change: change, changePercent: changePercent)
            }
        default:
            return
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if let parentViewController = parentViewController as? CompanyDashboardViewController {
            for view in parentViewController.view.subviews where view is UIScrollView && view.isHidden == false {
                (view as? UIScrollView)?.isScrollEnabled = true
            }
            parentViewController.isSelectingStockLine = false
        }
        if let price = company?.companyQuote?.price, let localeIdentifier = company?.localeIdentifier {
            setPriceLabel(price: price, localeIdentifier: localeIdentifier)
        } else {
            priceLabel.text = ""
        }
        if let stockChartView = chartView as? StockLineChartView {
            setUnselectedChangeAndLine(stockChartView: stockChartView)
        }
    }
}
