//
//  ContentView.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.categories, id: \.id) { category in
                            Section(content: {
                                ForEach(category.nofications, id: \.id) { notification in
                                    NotificationCell(type: notification.type,
                                                     date: notification.date,
                                                     color: notification.severity)
                                    
                                }
                                ViewAllCell(notificationCount: String(category.totalCount), categoryId: category.id)
                            }, header: {
                                Text(category.type)
                            })
                        }
                    }
                }
            }.onAppear(perform: {
                Task {
                    await viewModel.getCategories()
                }
            }).navigationTitle("Categories")
        }
        
    }
}

#Preview {
    ContentView()
}
