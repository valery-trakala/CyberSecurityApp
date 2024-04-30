//
//  AllNotificationsView.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct AllCategoryNotificationsView: View {
    let categoryId: Int
    
    @StateObject private var viewModel: AllCategoryNotificationsViewModel
    
    init(for categoryId: Int) {
        self.categoryId = categoryId
        self._viewModel = StateObject(wrappedValue: AllCategoryNotificationsViewModel(for: categoryId))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.notificationSections, id: \.date) { section in
                        Section(content: {
                            ForEach(section.notifications, id: \.id) { notification in
                                NotificationCell(
                                    type: notification.type,
                                    date: notification.date,
                                    color: notification.severity)
                                .onAppear {
                                    if isLastItem(notification) {
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
                            if viewModel.isNextPageLoading, section.date == viewModel.notificationSections.last!.date  {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                        })
                    }
                }
            }
        }
        .navigationTitle("Browsing")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.getCategories()
            }
        }
    }
    
    private func isLastItem(_ item: CategoryNotificationModel) -> Bool {
        if let lastItem = viewModel.notificationSections.last!.notifications.last {
            return item.id == lastItem.id
        }
        return false
    }
}

#Preview {
    ContentView()
}

