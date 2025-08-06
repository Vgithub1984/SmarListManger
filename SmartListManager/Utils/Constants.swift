import Foundation

/// App-wide constants and configuration
struct Constants {
    
    // MARK: - App Information
    struct App {
        static let name = "Smart List Manager"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let savedItems = "saved_items"
        static let userPreferences = "user_preferences"
    }
    
    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        // Animation durations
        static let shortAnimation: Double = 0.2
        static let mediumAnimation: Double = 0.3
        static let longAnimation: Double = 0.5
    }
    
    // MARK: - Validation
    struct Validation {
        static let maxItemTitleLength = 200
        static let minItemTitleLength = 1
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let genericError = "Something went wrong. Please try again."
        static let networkError = "Network connection failed. Please check your internet connection."
        static let saveError = "Failed to save your changes. Please try again."
        static let loadError = "Failed to load your data. Please try again."
    }
}

// MenuColors.swift
// Defines color coding for each menu type in SmartListManager.
// Created for color consistency across icons, buttons, and navigation elements.

import SwiftUI

/// Centralized color mapping for ContentView.Menu
struct MenuColors {
    /// Returns the color for a given menu type.
    static func color(for menu: ContentView.Menu) -> Color {
        switch menu {
        case .shopping:
            return .green
        case .todo:
            return .blue
        case .reminders:
            return .purple
        case .notes:
            return .orange
        case .deleted:
            return .red
        }
    }
} 