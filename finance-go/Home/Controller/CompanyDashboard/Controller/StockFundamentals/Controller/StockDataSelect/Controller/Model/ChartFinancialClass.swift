//
//  ChartFinancialClass.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/11/3.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Charts
import UIKit

// MARK: - StockLineChartView

class FinancialYAxisValueFormatter: IAxisValueFormatter {
    var dataType: StockData.DataType = .decimal
    var localeIdentifier: String = "en_US"

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if dataType == .decimal {
            return value.formatCurrencyUsingAbbrevation(localeIdentifier: localeIdentifier)
        } else if dataType == .original {
            return value.formatDecimalUsingAbbrevation()
        } else {
            return value.formatDecimalUsingAbbrevation() + "%"
        }
    }
}

class FinancialXAxisValueFormatter: IAxisValueFormatter {
    var entries: [ChartDataEntry]?

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let entries = entries {
            if let entry = entries.first(where: { entry in
                entry.x == round(value)
            }) {
                let temp = entry.data as? String ?? ""
                var date: String = ""
                if temp.count > 3 {
                    date = String(temp.dropLast(3))
                }
                return date
            }
        }
        return ""
    }
}

class XAxisRendererWithTicks: XAxisRenderer {
    override func drawLabel(context: CGContext, formattedLabel: String, x: CGFloat, y: CGFloat, attributes: [NSAttributedString.Key: Any], constrainedToSize: CGSize, anchor: CGPoint, angleRadians: CGFloat) {
        super.drawLabel(context: context, formattedLabel: formattedLabel, x: x, y: y, attributes: attributes, constrainedToSize: constrainedToSize, anchor: anchor, angleRadians: angleRadians)

        context.beginPath()

        context.move(to: CGPoint(x: x, y: y))
        context.setStrokeColor(UIColor.systemGray.cgColor)
        context.addLine(to: CGPoint(x: x, y: viewPortHandler.contentBottom))

        context.strokePath()
    }
}

class CircleMarker: MarkerImage {
    @objc var color: UIColor
    @objc var radius: CGFloat = 4

    @objc public init(color: UIColor) {
        self.color = color
        super.init()
    }

    override func draw(context: CGContext, point: CGPoint) {
        let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: circleRect)

        context.restoreGState()
    }
}

class FinancialLineChartView: LineChartView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        drawBordersEnabled = false

        leftAxis.enabled = false

        rightAxis.enabled = true
        rightAxis.setLabelCount(6, force: true)
        rightAxis.axisLineColor = .clear
        rightAxis.labelPosition = .outsideChart
        rightAxis.granularity = 1

        xAxis.enabled = true
        xAxis.forceLabelsEnabled = true
        xAxis.axisLineWidth = 1
        xAxis.setLabelCount(4, force: true)
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0.0
        xAxis.granularity = 1
        xAxis.gridColor = .clear
        let customXAxisRenderer = XAxisRendererWithTicks(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: getTransformer(forAxis: .left))
        xAxisRenderer = customXAxisRenderer

        marker = CircleMarker(color: .lineChartBlue)
        extraTopOffset = 20
        extraLeftOffset = 30
        extraBottomOffset = 20
        legend.enabled = false
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
        noDataText = "No Data".localized()
        if let gestureRecognizers = gestureRecognizers {
            for gestureRecongnizer in gestureRecognizers {
                if gestureRecongnizer is UIPanGestureRecognizer {
                    removeGestureRecognizer(gestureRecongnizer)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - StockLineChartDataSet

class FinancialLineChartDataSet: LineChartDataSet {
    override init(entries: [ChartDataEntry]?, label: String?) {
        super.init(entries: entries, label: label)
        drawCirclesEnabled = false
        lineWidth = 1.8
        highlightColor = .systemGray
        highlightLineDashLengths = [4, 2]
        drawVerticalHighlightIndicatorEnabled = true
        drawHorizontalHighlightIndicatorEnabled = false
        setColor(.lineChartBlue)
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}
