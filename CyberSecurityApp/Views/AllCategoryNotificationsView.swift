//
//  AllNotificationsView.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct AllCategoryNotificationsView: View {
    let type: String
    
    @StateObject private var viewModel: AllCategoryNotificationsViewModel
    
    init(for categoryId: Int, type: String, totalCount: Int) {
        self.type = type
        self._viewModel = StateObject(wrappedValue: AllCategoryNotificationsViewModel(for: categoryId, totalCount: totalCount))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(Array(viewModel.notificationSections.enumerated()), id: \.element.date) { (index, section) in
                        Section(content: {
                            ForEach(section.notifications, id: \.id) { notification in
                                NotificationCell(
                                    type: notification.type,
                                    date: viewModel.dateFormatterHelper.formatDate(date: notification.date, to: "h:mm:ss a"),
                                    color: notification.severity)
                                .onAppear {
                                    if viewModel.isLastNotification(notification), viewModel.isAllDataLoaded() {
                                        viewModel.isNextPageLoading = true
                                        Task {
                                            await viewModel.getCategories()
                                        }
                                    }
                                }
                            }
                        }, header: {
                            Text(section.date)
                        }, footer: {
                            if viewModel.isNextPageLoading, viewModel.isLastSection(section)  {
                                HStack {
                                    Spacer()
                                    ProgressView("Loading...")
                                    Spacer()
                                }.padding()
                            }
                        })
                    }
                }
            }
        }
        .navigationTitle(type)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.getCategories()
            }
        }
    }
}

#Preview {
    ContentView()
}

