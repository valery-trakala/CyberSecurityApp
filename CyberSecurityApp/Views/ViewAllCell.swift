//
//  ViewAllCell.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct ViewAllCell: View {
    let totalCount: Int
    let categoryId: Int
    let categoryType: String
    
    var body: some View {
        NavigationLink(destination: AllCategoryNotificationsView(
            for: categoryId,
            type: categoryType,
            totalCount: totalCount)) {
                Text("View All (\(totalCount) more)")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
    }
}

