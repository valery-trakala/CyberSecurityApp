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
    
    let dataFetcher: DataFetcherProtocol
    let dateFormatterHelper: DateFormatterHelperProtocol
    
    @Published var pageIndex = 1
    @Published var notificationSections: [NotificationsSectionModel] = []
    @Published var isLoading = true
    @Published var isNextPageLoading = false
    
    init(for categoryId: Int,
         totalCount: Int,
         dateFormatterHelper: DateFormatterHelperProtocol = DateFormatterHelper(),
         dataFetcher: DataFetcherProtocol = CategoriesDataFetcher()
    ) {
        self.categoryId = categoryId
        self.totalNotificationsCount = totalCount
        self.dateFormatterHelper = dateFormatterHelper
        self.dataFetcher = dataFetcher
    }
    
    func getCategories() async {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: categoryId, page: pageIndex, pageSize: pageSize)
            guard let response = response, !response.isEmpty else { return }
            loadedNotificationsCount += response.count
            
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
    
    private func createNotificationsSectionsFromResponse(response: [CategoryNotificationModelResponse]) -> [NotificationsSectionModel] {
        var sections: [NotificationsSectionModel] = []
        
        for (_, notification) in response.enumerated() {
            let sectionDate = dateFormatterHelper.formatDate(date: notification.date, to: "MMM dd, yyyy")
            
            if let index = sections.firstIndex(where: { $0.date == sectionDate }) {
                sections[index].notifications.append(notification)
            } else {
                sections.append(NotificationsSectionModel(notifications: [notification], date: sectionDate))
            }
        }
        
        return sections
    }
    
    func isLastNotification(_ notification: CategoryNotificationModelResponse) -> Bool {
        guard let lastSection = notificationSections.last, let lastNotification = lastSection.notifications.last else { return false }
        return lastNotification.id == notification.id
    }
    
    func isLastSection(_ section: NotificationsSectionModel) -> Bool {
        guard let lastSection = notificationSections.last else { return false }
        return lastSection.date == section.date
    }
    
    func isAllDataLoaded() -> Bool {
        return loadedNotificationsCount != totalNotificationsCount
    }
}
