//
//  AllCategoryNotificationsViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import Foundation

final class AllCategoryNotificationsViewModel: ObservableObject {
    private let pageSize = 10
    let categoryId: Int
    
    let dataFetcher = CategoriesDataFetcher()
    let dateFormatterHelper: DateFormatterHelperProtocol
    
    @Published var pageIndex = 1
    @Published var notificationSections: [NotificationsSectionModel] = []
    @Published var isLoading = true
    @Published var isNextPageLoading = false
    
    init(for categoryId: Int, dateFormatterHelper: DateFormatterHelperProtocol = DateFormatterHelper()) {
        self.categoryId = categoryId
        self.dateFormatterHelper = dateFormatterHelper
    }
    
    func getCategories() async {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: categoryId, page: pageIndex, pageSize: pageSize)
            guard let response = response, !response.isEmpty else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let sections = self?.createNotificationsSectionsFromResponse(response: response) else { return }
      
                self?.notificationSections = self != nil ? self!.notificationSections + sections : sections
                self?.isLoading = false
                self?.isNextPageLoading = false
                self?.pageIndex += 1
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createNotificationsSectionsFromResponse(response: [CategoryNotificationModel]) -> [NotificationsSectionModel]? {
        var sections: [NotificationsSectionModel] = []
        
        for (_, notification) in response.enumerated() {
            guard let sectionDate = dateFormatterHelper.formatDate(from: notification.date, to: "MMM dd, yyyy") else { return nil }
            
            if let index = sections.firstIndex(where: { $0.date == sectionDate }) {
                sections[index].notifications.append(notification)
            } else {
                guard let notificationDate = dateFormatterHelper.formatDate(from: notification.date, to: "h:mm:ss a") else { return nil }
                let formattedNotification = CategoryNotificationModel(
                    id: notification.id,
                    categoryId: notification.categoryId,
                    type: notification.type,
                    severity: notification.severity,
                    date: notificationDate)
                
                sections.append(NotificationsSectionModel(notifications: [formattedNotification], date: sectionDate))
            }
        }
        
        return sections
    }
}
