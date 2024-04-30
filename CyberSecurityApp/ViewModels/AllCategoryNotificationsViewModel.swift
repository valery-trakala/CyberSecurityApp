//
//  AllCategoryNotificationsViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import Foundation

final class AllCategoryNotificationsViewModel: ObservableObject {
    let dataFetcher = CategoriesDataFetcher()
    
    @Published var notifications: [String: [CategoryNotificationModel]] = [:]
    @Published var isLoading = true
    
    func getCategories() async throws {
        do {
            let response = try await dataFetcher.getNotifications(categoryId: 1, page: 1, pageSize: 3)

            guard let response = response, !response.isEmpty else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
