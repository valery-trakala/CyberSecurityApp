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
                        ForEach(viewModel.categories.sorted(by: { $0.key > $1.key }), id: \.key) {
                            key, category in
                            Section(content: {
                                ForEach(category.nofications, id: \.id) { notification in
                                    NotificationCell(type: notification.type,
                                                   date: notification.date,
                                                   color: notification.severity)
                                    
                                }
                                ViewAllCell(notificationCount: String(category.totalCount), categoryId: category.id)
                            }, header: {
                                Text(key)
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
