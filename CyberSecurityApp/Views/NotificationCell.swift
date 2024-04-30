//
//  NotificationCell.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 30/04/2024.
//

import SwiftUI

struct NotificationCell: View {
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
