//
//  Card.swift
//  SmartListManager
//
//  Data models for cards and card storage in the app.
//  Used throughout the app (see ContentView.swift, MenuSheets/*.swift, etc.)
//
//  Created by Varun Patel on 8/5/25.
//

import Foundation

/// Represents a single card (task, note, etc.) in a menu.
/// Used in ContentView.swift, MenuSheets/*.swift, etc.
struct Card: Codable, Identifiable, Equatable {
    let id: UUID         // Unique identifier for the card
    let name: String     // Card name/title
    let menu: ContentView.Menu // The menu this card belongs to (see ContentView.swift)
    let created: Date    // Creation date
}

/// Storage model for persisting cards by menu in UserDefaults.
/// Used in ContentView.swift for saving/loading.
struct CardStorage: Codable {
    var cardsByMenu: [ContentView.Menu.RawValue: [Card]]
}

// Helper struct for migration from old format (pre-v1)
// Used in ContentView.swift for migration logic.
struct CardStorageOld: Codable {
    var cardsByMenu: [ContentView.Menu.RawValue: [String]]
} 