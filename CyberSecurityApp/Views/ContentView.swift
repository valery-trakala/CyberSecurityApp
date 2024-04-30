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
                        ForEach(Array(viewModel.categories.sorted(by: { $0.key > $1.key })), id: \.key) {
                            key, category in
                            Section(content: {
                                ForEach(category.nofications, id: \.id) { notification in
                                    NoficationCell(type: notification.type,
                                                   date: notification.date,
                                                   color: notification.severity)
                                    
                                }
                                ViewAllCell(notificationCount: String(category.totalCount))
                            }, header: {
                                Text(key)
                            })
                        }
                    }
                }
            }.onAppear(perform: {
                Task {
                    try await viewModel.getCategories()
                }
            }).navigationTitle("Categories")
        }
        
    }
}

#Preview {
    ContentView()
}


struct NoficationCell: View {
    let size: CGFloat = 10
    let type: String
    let date: String
    let color: Severity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(type)
                    .font(.headline)
                Text(date)
            }
            Spacer()
            Circle()
                .frame(width: size, height: size)
                .foregroundStyle(getColor())
        }
    }
    
    private func getColor() -> Color {
        switch color {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .red
        case .critical:
            return .black
        }
    }
}

struct ViewAllCell: View {
    let notificationCount: String
    
    var body: some View {
        NavigationLink {
            DetailPage()
        } label: {
            Text("View All (\(notificationCount) more)")
                .font(.headline)
                .foregroundStyle(.blue)
        }
        
    }
}

struct DetailPage: View {
    
    var body: some View {
        Text("DetailPage")
    }
}
