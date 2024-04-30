//
//  DateFormatterHelper.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import Foundation

protocol DateFormatterHelperProtocol {
    func formatDate(from: String, to: String) -> String?
}

final class DateFormatterHelper: DateFormatterHelperProtocol {
    private let dateFormatter = DateFormatter()
    
    func formatDate(from: String, to: String) -> String? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let date = dateFormatter.date(from: from) else { return nil }
        
        dateFormatter.dateFormat = to
        return dateFormatter.string(from: date)
    }
}
