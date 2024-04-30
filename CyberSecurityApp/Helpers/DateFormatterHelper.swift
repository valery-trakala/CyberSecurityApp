//
//  DateFormatterHelper.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import Foundation

protocol DateFormatterHelperProtocol {
    func formatDate(date: Date, to: String) -> String
}

final class DateFormatterHelper: DateFormatterHelperProtocol {
    private let dateFormatter = DateFormatter()
    
    func formatDate(date: Date, to: String) -> String {
        dateFormatter.dateFormat = to
        return dateFormatter.string(from: date)
    }
}
