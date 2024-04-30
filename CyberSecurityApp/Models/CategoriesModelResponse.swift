//
//  CategoriesResponse.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation



struct CategoriesModelResponse: Decodable {
    var id: Int
    var type: String
    var notifications: Int
}

struct CategoryNotificationModelResponse: Decodable {
    var id: Int
    var categoryId: Int
    var type: String
    var severity: Severity
    var date: String
}

enum Severity: String, Decodable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
}

struct CategoryModel {
    var id: Int
    var type: String
    var totalCount: Int
    var nofications: [CategoryNotificationModelResponse]
}

struct NotificationsSectionModel {
    var notifications: [CategoryNotificationModelResponse]
    var date: String
}
