//
//  ItemRowView.swift
//  SmartListManager
//
//  A reusable view component for displaying a single item in a list.
//  Used in various list views throughout the app.
//

import SwiftUI

/// Displays a single item row with a checkbox, title, and timestamp.
/// The onToggle closure is provided by the parent view (see usage in parent list views).
struct ItemRowView: View {
    let item: Item
    let onToggle: () -> Void // Called from parent view to toggle completion
    
    var body: some View {
        HStack {
            // Checkbox button to mark item as completed/incomplete
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Item title, strikethrough if completed
            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .gray : .primary)
                .lineLimit(2)
            
            Spacer()
            
            // Relative timestamp (e.g., "2 hours ago")
            Text(item.updatedAt, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        ItemRowView(
            item: Item(title: "Sample completed item", isCompleted: true)
        ) {
            // Toggle action
        }
        
        ItemRowView(
            item: Item(title: "Sample incomplete item", isCompleted: false)
        ) {
            // Toggle action
        }
    }
} 