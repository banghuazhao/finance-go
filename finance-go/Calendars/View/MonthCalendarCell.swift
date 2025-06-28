//
//  MonthCalendarCell.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/5.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import JTAppleCalendar
import Then
import UIKit

class MonthCalendarCell: UITableViewCell {
    var calendars: [FGCalendar]? {
        didSet {
            guard let calendars = calendars else { return }

            let same = calendars.elementsEqual(oldValue ?? []) {
                $0.date == $1.date && $0.symbol == $1.symbol
            }

            guard !same else { return }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            let specialformatter = DateFormatter()
            specialformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            datesWithValue = calendars.map { calendar in
                if !(calendar is EconomicCalendar) {
                    if let date = formatter.date(from: calendar.date) {
                        return date
                    }
                    return Date()
                } else {
                    if let calendarDate = specialformatter.date(from: calendar.date) {
                        if let date = formatter.date(from: calendarDate.stringDay_yyyy_MM_dd) {
                            return date
                        }
                    }
                    return Date()
                }
            }
            datesWithValue = Array(Set(datesWithValue))
            startDate = datesWithValue.min() ?? Date().addingTimeInterval(-60 * 60 * 24 * 30 * 6)
            endDate = datesWithValue.max() ?? Date().addingTimeInterval(60 * 60 * 24 * 30 * 6)
            monthView.reloadData()
            monthView.scrollToDate(Date(), animateScroll: false)
            if Date().get(.month, .year) == endDate.get(.month, .year) {
                showRightButton.isHidden = true
            } else {
                showRightButton.isHidden = false
            }
            if Date().get(.month, .year) == startDate.get(.month, .year) {
                showLeftButton.isHidden = true
            } else {
                showLeftButton.isHidden = false
            }
        }
    }

    var startDate = Date().addingTimeInterval(-60 * 60 * 24 * 30 * 6)
    var endDate = Date().addingTimeInterval(60 * 60 * 24 * 30 * 6)
    var datesWithValue = [Date]()

    lazy var monthLabel = UILabel().then { label in
        label.font = UIFont.title
        label.textAlignment = .center
        label.textColor = .white1
    }

    lazy var showLeftButton = UIButtonLargerTouchArea().then { button in
        let image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate).tinted(with: .white1)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.transform = CATransform3DMakeScale(-1, 1, 1)
        button.addTarget(self, action: #selector(showLeft), for: .touchUpInside)
    }

    lazy var showRightButton = UIButtonLargerTouchArea().then { button in
        let image = UIImage(named: "button_rightArrow")?.withRenderingMode(.alwaysTemplate).tinted(with: .white1)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showRight), for: .touchUpInside)
    }

    lazy var weekDaysStackView = UIStackView().then { sv in
        sv.distribution = .fillEqually
        let formatter = DateFormatter()
        formatter.locale = .current
        let weekDays: [String] = formatter.shortWeekdaySymbols ?? ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for weekDay in weekDays {
            let label = UILabel()
            label.text = weekDay
            label.textColor = .white1
            label.textAlignment = .center
            sv.addArrangedSubview(label)
        }
    }

    lazy var monthView = JTACMonthView().then { mv in
        mv.scrollingMode = .stopAtEachCalendarFrame
        mv.scrollDirection = .horizontal
        mv.backgroundColor = .clear
        mv.showsHorizontalScrollIndicator = false
        mv.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        mv.calendarDelegate = self
        mv.calendarDataSource = self
        mv.minimumLineSpacing = 0
        mv.minimumInteritemSpacing = 0
        mv.sectionInset.left = 0
        mv.sectionInset.right = 0
        mv.allowsRangedSelection = false
        mv.selectDates([Date()])
        mv.scrollToDate(Date(), animateScroll: false)
        setupDateLabel(date: Date())
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(monthLabel)
        contentView.addSubview(showLeftButton)
        contentView.addSubview(showRightButton)
        contentView.addSubview(weekDaysStackView)
        contentView.addSubview(monthView)

        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }

        showLeftButton.snp.makeConstraints { make in
            make.right.equalTo(monthLabel.snp.left).offset(-20)
            make.centerY.equalTo(monthLabel)
            make.height.equalTo(14)
        }

        showRightButton.snp.makeConstraints { make in
            make.left.equalTo(monthLabel.snp.right).offset(20)
            make.centerY.equalTo(monthLabel)
            make.height.equalTo(14)
        }

        weekDaysStackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        monthView.snp.makeConstraints { make in
            make.top.equalTo(weekDaysStackView.snp.bottom).offset(2)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(280)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - actions

extension MonthCalendarCell {
    @objc func showLeft() {
        monthView.scrollToSegment(.previous)
    }

    @objc func showRight() {
        monthView.scrollToSegment(.next)
    }
}

// MARK: - methods

extension MonthCalendarCell {
    func setupDateLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yMMMM")
        monthLabel.text = dateFormatter.string(from: date)
    }

    func handleCellConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? DateCell else { return }
        cell.isDateSelected = cellState.isSelected
    }
}

// MARK: - JTACMonthViewDataSource

extension MonthCalendarCell: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            generateOutDates: .tillEndOfRow
        )
        return parameters
    }
}

// MARK: - JTACMonthViewDelegate

extension MonthCalendarCell: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        cell.isHidden = cellState.dateBelongsTo != .thisMonth
        cell.dateLabel.text = cellState.text
        cell.hasCalendar = datesWithValue.contains(date)

        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        setupDateLabel(date: date)
        handleCellConfiguration(cell: cell, cellState: cellState)
        if calendars is [EarningCalendar] {
            NotificationCenter.default.post(name: .didSelectEarningCalendarDate, object: date)
        } else if calendars is [IPOCalendar] {
            NotificationCenter.default.post(name: .didSelectIPOCalendarDate, object: date)
        } else if calendars is [StockSplitCalendar] {
            NotificationCenter.default.post(name: .didSelectStockSplitCalendarDate, object: date)
        } else if calendars is [DividendCalendar] {
            NotificationCenter.default.post(name: .didSelectDividendCalendarDate, object: date)
        } else if calendars is [EconomicCalendar] {
            NotificationCenter.default.post(name: .didSelectEconomicCalendarDate, object: date)
        }
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        setupDateLabel(date: date)
        if visibleDates.monthDates.last?.date.get(.month, .year) == endDate.get(.month, .year) {
            showRightButton.isHidden = true
        } else {
            showRightButton.isHidden = false
        }
        if visibleDates.monthDates.first?.date.get(.month, .year) == startDate.get(.month, .year) {
            showLeftButton.isHidden = true
        } else {
            showLeftButton.isHidden = false
        }
    }
}
