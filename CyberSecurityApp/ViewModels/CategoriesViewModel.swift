//
//  CategoriesViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    let dataFetcher = CategoriesDataFetcher()
    
    @Published var categories: [String: CategoryModel] = [:]
    @Published var isLoading = true
    
    func getCategories() async throws {
        do {
            let response = try await dataFetcher.getCategories()
            
            guard let response = response, !response.isEmpty else { return }
            //TODO: try to handle it by "for ASYNC _ in"
            //            var asyncTasks = [Task<[CategoryNotification], Error>]()
            //            for category in response {
            //                asyncTasks.append(Task {
            //                    try await dataFetcher.getNotifications(categoryId: category.id, page: 1, pageSize: 3)
            //                })
            //            }
            
            async let networkNotifications = dataFetcher.getNotifications(categoryId: response[0].id)
            async let browserNotifications = dataFetcher.getNotifications(categoryId: response[1].id)
            
            let combinedCategories = try await [networkNotifications, browserNotifications]
            
            DispatchQueue.main.async { [weak self] in
                for (index, category) in response.enumerated() {
                    guard let notifications = combinedCategories[index] else { continue }
                    
                    self?.categories[category.type] = CategoryModel(
                        id: category.id,
                        type: category.type,
                        totalCount: category.notifications,
                        nofications: notifications)
                }
                self?.isLoading = false
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}



