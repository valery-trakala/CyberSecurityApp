//
//  CategoriesViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    let dataFetcher: CategoriesDataFetcher
    
    @Published var categories: [CategoryModel] = []
    @Published var isLoading = true
    
    init(dataFetcher: CategoriesDataFetcher = CategoriesDataFetcher()) {
        self.dataFetcher = dataFetcher
    }
    
    func getCategories() async {
        do {
            let response = try await dataFetcher.getCategories()
            
            guard let response = response, !response.isEmpty else { return }
            //TODO: try to handle it by "for ASYNC _ in"
            //            var asyncNotificaitonTasks = [Task<[CategoryNotificationModel], Error>]()
            
            async let networkNotifications = dataFetcher.getNotifications(categoryId: response[0].id)
            async let browserNotifications = dataFetcher.getNotifications(categoryId: response[1].id)
            
            let combinedNotifications = try await [networkNotifications, browserNotifications]
            
            DispatchQueue.main.async { [weak self] in
                var categories: [CategoryModel] = []
                for (index, category) in response.enumerated() {
                    guard let notifications = combinedNotifications[index] else { continue }
                    
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



