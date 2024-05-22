//
//  CategoriesViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

let page = 1
let pagesize = 3

final class CategoriesViewModel: ObservableObject {
    private let dataFetcher: DataFetcherProtocol
    let dateFormatterHelper: DateFormatterHelperProtocol
    
    @Published var categories: [CategoryModel] = []
    @Published var isLoading = true
    
    init(dataFetcher: DataFetcherProtocol = CategoriesDataFetcher(),
         dateFormatterHelper: DateFormatterHelperProtocol = DateFormatterHelper()) {
        self.dataFetcher = dataFetcher
        self.dateFormatterHelper = dateFormatterHelper
    }
    
    func getCategories() async {
        do {
            let response = try await dataFetcher.getCategories()
            guard let response = response, !response.isEmpty else { return }

            let combinedNotifications = try await withThrowingTaskGroup(of: [CategoryNotificationModelResponse]?.self) { group -> [[CategoryNotificationModelResponse]] in
                var notificationsGroup: [[CategoryNotificationModelResponse]] = []

                for i in response {
                    group.addTask { [weak self] in
                        try await self?.dataFetcher.getNotifications(categoryId: i.id, page: page, pageSize: pagesize)
                    }
                }
                
                for try await t in group {
                    guard let newNot = t else { continue }
                    notificationsGroup.append(newNot)
                }
                
                return notificationsGroup
            }

            Task { @MainActor [weak self] in
                var categories: [CategoryModel] = []
                for (index, category) in response.enumerated() {
                    let notifications = combinedNotifications[index]
                    
                    categories.append(CategoryModel(
                        id: category.id,
                        type: category.type,
                        totalCount: category.notifications,
                        nofications: notifications)
                    )
                }
                self?.categories = categories
                self?.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
