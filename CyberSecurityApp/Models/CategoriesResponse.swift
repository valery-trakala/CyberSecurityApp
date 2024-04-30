//
//  CategoriesResponse.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation



struct CategoriesResponse: Decodable {
    var id: Int
    var type: String
    var notifications: Int
}

struct CategoryNotificationModel: Decodable {
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
    var nofications: [CategoryNotificationModel]
}

struct NotificationsSectionModel {
    var notifications: [CategoryNotificationModel]
    var date: String
}
