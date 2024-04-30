//
//  CategoriesViewModel.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

final class CategoriesViewModel: ObservableObject {
    let dataFetcher: DataFetcherProtocol
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
            //TODO: try to handle it by "for ASYNC _ in"
            //            var asyncNotificaitonTasks = [Task<[CategoryNotificationModel], Error>]()
            
            let page = 1
            let pagesize = 3
            async let networkNotifications = dataFetcher.getNotifications(categoryId: response[0].id, page: page, pageSize: pagesize)
            async let browserNotifications = dataFetcher.getNotifications(categoryId: response[1].id, page: page, pageSize: pagesize)
            
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



