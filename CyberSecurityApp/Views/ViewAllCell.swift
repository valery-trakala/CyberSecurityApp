//
//  ViewAllCell.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct ViewAllCell: View {
    let notificationCount: String
    let categoryId: Int
    
    var body: some View {

        NavigationLink(destination: AllCategoryNotificationsView(for: categoryId)) {
            Text("View All (\(notificationCount) more)")
                .font(.headline)
                .foregroundStyle(.blue)
        }
    }
}

