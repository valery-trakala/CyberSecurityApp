//
//  AllCategoryNotificationsViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import Foundation

final class AllCategoryNotificationsViewModel: ObservableObject {
    let categoryId: Int
    let dataFetcher = CategoriesDataFetcher()
    
    @Published var notifications: [String: [CategoryNotificationModel]] = [:]
    @Published var notificationsDates: [String] = []
    @Published var isLoading = true
    
    init(for categoryId: Int) {
        self.categoryId = categoryId
    }
    
    func getCategories() async throws {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: categoryId, page: 1, pageSize: 99)
            guard let response = response, !response.isEmpty else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let (notifications, notificationsDates) = self?.parseNotificationsResponse(response: response) else { return }
                
                self?.notificationsDates = notificationsDates
                self?.notifications = notifications
                self?.isLoading = false
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func parseNotificationsResponse(response: [CategoryNotificationModel]) -> (
        [String: [CategoryNotificationModel]], [String]
    )? {
        var configuredNotifications:[String: [CategoryNotificationModel]] = [:]
        var sortedNoficatificationsDate: [String] = []
        
        for (_, notification) in response.enumerated() {
            let formattedDate = self.formatDate(from: notification.date)
            guard let date = formattedDate else { return nil }
            
            if var notificationsArray = configuredNotifications[date] {
                notificationsArray.append(notification)
                configuredNotifications[date] = notificationsArray
            } else {
                configuredNotifications[date] = [notification]
                sortedNoficatificationsDate.append(date)
            }
        }
        
        return (configuredNotifications, sortedNoficatificationsDate)
    }
    
    private func formatDate(from: String, to: String = "MMM dd, yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let date = dateFormatter.date(from: from) else { return nil }
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = to
        
        let newDateString = newDateFormatter.string(from: date)
        
        return newDateString
    }
}
