//
//  CompanyRating.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/27/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import Foundation

class CompanyRating {
    var date: String
    var rating: String
    var ratingScore: Int
    var ratingRecommendation: String
    var ratingDetailsDCFScore: Int
    var ratingDetailsDCFRecommendation: String
    var ratingDetailsROEScore: Int
    var ratingDetailsROERecommendation: String
    var ratingDetailsROAScore: Int
    var ratingDetailsROARecommendation: String
    var ratingDetailsDEScore: Int
    var ratingDetailsDERecommendation: String
    var ratingDetailsPEScore: Int
    var ratingDetailsPERecommendation: String
    var ratingDetailsPBScore: Int
    var ratingDetailsPBRecommendation: String

    init(date: String,
         rating: String,
         ratingScore: Int,
         ratingRecommendation: String,
         ratingDetailsDCFScore: Int,
         ratingDetailsDCFRecommendation: String,
         ratingDetailsROEScore: Int,
         ratingDetailsROERecommendation: String,
         ratingDetailsROAScore: Int,
         ratingDetailsROARecommendation: String,
         ratingDetailsDEScore: Int,
         ratingDetailsDERecommendation: String,
         ratingDetailsPEScore: Int,
         ratingDetailsPERecommendation: String,
         ratingDetailsPBScore: Int,
         ratingDetailsPBRecommendation: String) {
        self.date = date
        self.rating = rating
        self.ratingScore = ratingScore
        self.ratingRecommendation = ratingRecommendation
        self.ratingDetailsDCFScore = ratingDetailsDCFScore
        self.ratingDetailsDCFRecommendation = ratingDetailsDCFRecommendation
        self.ratingDetailsROEScore = ratingDetailsROEScore
        self.ratingDetailsROERecommendation = ratingDetailsROERecommendation
        self.ratingDetailsROAScore = ratingDetailsROAScore
        self.ratingDetailsROARecommendation = ratingDetailsROARecommendation
        self.ratingDetailsDEScore = ratingDetailsDEScore
        self.ratingDetailsDERecommendation = ratingDetailsDERecommendation
        self.ratingDetailsPEScore = ratingDetailsPEScore
        self.ratingDetailsPERecommendation = ratingDetailsPERecommendation
        self.ratingDetailsPBScore = ratingDetailsPBScore
        self.ratingDetailsPBRecommendation = ratingDetailsPBRecommendation
    }
}
