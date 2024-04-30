//
//  ViewAllCell.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct ViewAllCell: View {
    let notificationCount: String
    
    var body: some View {
        NavigationLink {
            AllCategoryNotificationsView()
        } label: {
            Text("View All (\(notificationCount) more)")
                .font(.headline)
                .foregroundStyle(.blue)
        }
    }
}

