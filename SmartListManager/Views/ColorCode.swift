// ColorCode.swift
// Central place to define Menu details: icons and colors for each menu type.

import SwiftUI

// Enum representing Menu types (should match ContentView.Menu if needed)
enum MenuType: String, CaseIterable, Identifiable, Codable {
    case todo = "To Do"
    case shopping = "Shopping List"
    case reminders = "Reminders"
    case notes = "Notes"
    case deleted = "Deleted"
    
    var id: String { rawValue }
}

struct MenuDetails {
    let icon: String
    let color: Color
    
    static let allDetails: [MenuType: MenuDetails] = [
        .todo: MenuDetails(icon: "checkmark.square", color: .blue),
        .shopping: MenuDetails(icon: "cart", color: .green),
        .reminders: MenuDetails(icon: "bell", color: .purple),
        .notes: MenuDetails(icon: "note.text", color: .orange),
        .deleted: MenuDetails(icon: "trash", color: .red)
    ]
    
    static func forMenu(_ menu: MenuType) -> MenuDetails {
        return allDetails[menu]!
    }
}

// Optional: Convenience extensions to map ContentView.Menu to MenuType
extension ContentView.Menu {
    var menuType: MenuType? { MenuType(rawValue: self.rawValue) }
    var details: MenuDetails? {
        guard let type = menuType else { return nil }
        return MenuDetails.forMenu(type)
    }
}
