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
    
    var loadedNotificationsCount = 0
    let totalNotificationsCount: Int
    
    let dataFetcher = CategoriesDataFetcher()
    let dateFormatterHelper: DateFormatterHelperProtocol
    
    @Published var pageIndex = 1
    @Published var notificationSections: [NotificationsSectionModel] = []
    @Published var isLoading = true
    @Published var isNextPageLoading = false
    
    init(for categoryId: Int, totalCount: Int, dateFormatterHelper: DateFormatterHelperProtocol = DateFormatterHelper()) {
        self.categoryId = categoryId
        self.dateFormatterHelper = dateFormatterHelper
        self.totalNotificationsCount = totalCount
    }
    
    func getCategories() async {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: categoryId, page: pageIndex, pageSize: pageSize)
            guard let response = response, !response.isEmpty else { return }
            loadedNotificationsCount += response.count
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
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
    
    private func createNotificationsSectionsFromResponse(response: [CategoryNotificationModelResponse]) -> [NotificationsSectionModel]? {
        var sections: [NotificationsSectionModel] = []
        
        for (_, notification) in response.enumerated() {
            guard let sectionDate = dateFormatterHelper.formatDate(from: notification.date, to: "MMM dd, yyyy") else { return nil }
            
            if let index = sections.firstIndex(where: { $0.date == sectionDate }) {
                sections[index].notifications.append(notification)
            } else {
                guard let notificationDate = dateFormatterHelper.formatDate(from: notification.date, to: "h:mm:ss a") else { return nil }
                let formattedNotification = CategoryNotificationModelResponse(
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
    
    func isLastNotification(_ notification: CategoryNotificationModelResponse) -> Bool {
        let lastNotification = notificationSections.last!.notifications.last!
        return lastNotification.id == notification.id
    }
    
    func isLastSection(_ section: NotificationsSectionModel) -> Bool {
        let lastSection = notificationSections.last!
        return lastSection.date == section.date
    }
    
    func isAllDataLoaded() -> Bool {
        return loadedNotificationsCount != totalNotificationsCount
    }
}
