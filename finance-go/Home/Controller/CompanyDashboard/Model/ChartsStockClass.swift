//
//  ChartsStockClass.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/17.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Charts
import UIKit

// MARK: - ChartMarker
class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 13),
        .foregroundColor: UIColor.white2,
        .backgroundColor: UIColor.clear,
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        if let dateString = entry.data as? String {
            text = dateString
            print(entry.x, entry.y)
        }
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let originY = chartView?.bounds.origin.y ?? rect.origin.y
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: originY + (rect.size.height - size.height) / 2 + 10,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}


// MARK: - StockLineChartView
class StockLineChartView: LineChartView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.rightAxis.enabled = false
        self.leftAxis.enabled = false
        self.xAxis.enabled = false
        self.legend.enabled = false
        self.xAxis.axisMinimum = 0.0
        self.minOffset = 0
        self.extraTopOffset = 30
        self.doubleTapToZoomEnabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.noDataText = ""
        let marker = ChartMarker()
        marker.chartView = self
        self.marker = marker
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func nsuiTouchesBegan(_ touches: Set<NSUITouch>, withEvent event: NSUIEvent?) {
        super.nsuiTouchesBegan(touches, withEvent: event)
        if let location = touches.first?.location(in: self) {
            ImpactManager.shared.generate()
            let high = getHighlightByTouchPoint(location)
            highlightValue(high, callDelegate: true)
        }
    }

    func unHighlightValue() {
        lastHighlighted = nil
        _indicesToHighlight.removeAll(keepingCapacity: false)
        if let delegate = delegate {
            delegate.chartValueNothingSelected?(self)
        }

        // redraw the chart
        setNeedsDisplay()
    }
}

// MARK: - StockLineChartDataSet
class StockLineChartDataSet: LineChartDataSet {
    override init(entries: [ChartDataEntry]?, label: String?) {
        super.init(entries: entries, label: label)
        self.drawCirclesEnabled = false
        self.lineWidth = 1.8
        self.highlightColor = .white2
        self.drawHorizontalHighlightIndicatorEnabled = false
        self.setColor(.white1)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
