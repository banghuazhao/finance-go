//
//  Notification.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 2021/10/3.
//  Copyright © 2021 Banghua Zhao. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didAddWatchCompany = Notification.Name("didAddWatchCompany")
    static let didRemoveWatchCompany = Notification.Name("didRemoveWatchCompany")
    
    static let companiesSearchTextDidChange = Notification.Name("companiesSearchTextDidChange")
    static let companiesSearchBarTextDidEndEditing = Notification.Name("companiesSearchBarTextDidEndEditing")
    static let companiesSearchBarCancelButtonClicked = Notification.Name("companiesSearchBarCancelButtonClicked")
    
    
    static let didSelectEarningCalendarDate = Notification.Name("didSelectEarningCalendarDate")
    static let didSelectIPOCalendarDate = Notification.Name("didSelectIPOCalendarDate")
    static let didSelectStockSplitCalendarDate = Notification.Name("didSelectStockSplitCalendarDate")
    static let didSelectDividendCalendarDate = Notification.Name("didSelectDividendCalendarDate")
    static let didSelectEconomicCalendarDate = Notification.Name("didSelectEconomicCalendarDate")
    
}
