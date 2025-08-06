//
//  Item.swift
//  SmartListManager
//
//  Created by Varun Patel on 8/5/25.
//

import Foundation

/// Represents a list item in the SmartListManager app
struct Item: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func toggleCompletion() {
        isCompleted.toggle()
        updatedAt = Date()
    }
}
