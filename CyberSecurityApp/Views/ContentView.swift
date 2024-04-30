//
//  ContentView.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CategoriesViewModel()
    
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
                                                     date: viewModel.dateFormatterHelper.formatDate(date: notification.date,
                                                                                                    to: "M/d/yyyy, h:mm a"),
                                                     color: notification.severity)
                                }
                                ViewAllCell(
                                    totalCount: category.totalCount,
                                    categoryId: category.id,
                                    categoryType: category.type)
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
