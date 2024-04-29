//
//  CategoriesViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    let dataFetcher = NetworkDataFetcher()
    
    @Published var categories: [String: Categories] = [:]
    @Published var isLoading = true
    
    func getCategories() async throws {
        do {
            let response = try await dataFetcher.getCategories()
            
            guard let response = response, !response.isEmpty else { return }
            
            async let networkCategories = dataFetcher.getNotifications(categoryId: response[0].id)
            async let browserCategories = dataFetcher.getNotifications(categoryId: response[1].id)
            
            let combinedCategories = try await [networkCategories, browserCategories]
            
            guard let networkCategories = combinedCategories[0], let browserCategories = combinedCategories[1] else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.categories[response[0].type] = Categories(
                    type: response[0].type,
                    totalCount: response[0].notifications,
                    nofications: networkCategories)
                
                self?.categories[response[1].type] = Categories(
                    type: response[1].type,
                    totalCount: response[1].notifications,
                    nofications: browserCategories)
                
                self?.isLoading = false
            }

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSpecialCategories(id: Int) {
      
    }
    
     
}



