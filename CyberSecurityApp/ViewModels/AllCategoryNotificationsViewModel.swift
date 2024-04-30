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
    
    @Published var notificationSections: [AllNotificationsSectionModel] = []
    @Published var isLoading = true
    
    init(for categoryId: Int) {
        self.categoryId = categoryId
    }
    
    func getCategories() async throws {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: categoryId, page: 1, pageSize: 99)
            guard let response = response, !response.isEmpty else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let sections = self?.parseNotificationsResponse(response: response) else { return }
                
                self?.notificationSections = sections
                self?.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func parseNotificationsResponse(response: [CategoryNotificationModel]) -> [AllNotificationsSectionModel]? {
        var sections: [AllNotificationsSectionModel] = []
        
        for (_, notification) in response.enumerated() {
            let formattedDate = self.formatDate(from: notification.date)
            guard let date = formattedDate else { return nil }
       
            
            if let index = sections.firstIndex(where: { $0.date == date }) {
                sections[index].notifications.append(notification)
            } else {
                sections.append(AllNotificationsSectionModel(notifications: [notification], date: date))
            }
            
        }
        
        return sections
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
