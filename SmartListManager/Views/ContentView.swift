//
//  ContentView.swift
//  SmartListManager
//
//  Main entry point for the SmartListManager app. Handles menu navigation, card storage, and sheet presentation.
//  Created by Varun Patel on 8/5/25.
//

import SwiftUI

/// The main view for the app, displaying the menu and handling navigation and data persistence.
struct ContentView: View {
    /// Enum representing the different menu types in the app.
    enum Menu: String, CaseIterable, Identifiable, Codable {
        case todo = "To Do"
        case shopping = "Shopping List"
        case reminders = "Reminders"
        case notes = "Notes"
        case deleted = "Deleted"
        
        var id: String { rawValue }
        /// Returns the SF Symbol name for each menu type.
        var icon: String {
            switch self {
            case .todo: return "checkmark.square"
            case .shopping: return "cart"
            case .reminders: return "bell"
            case .notes: return "note.text"
            case .deleted: return "trash"
            }
        }
    }
    
    // MARK: - State Properties
    @State private var selectedMenu: Menu? = nil // Currently selected menu
    @State private var showSheet: Bool = false   // Controls sheet presentation
    
    @State private var showAddSheet = false    // Controls add card sheet
    @State private var newCardName: String = "" // New card name input
    @State private var cardsByMenu: [Menu: [Card]] = [:] // Card storage by menu
    
    private let storageKey = "cardsByMenuStorageKeyV1" // UserDefaults key
    
    // MARK: - Card Management
    /// Moves a card to the Deleted menu instead of permanent deletion.
    /// Called by onDelete closures in all menu sheets (see MenuSheets/*.swift)
    private func moveCardToDeleted(_ card: Card) {
        // Remove from current menu
        if var cards = cardsByMenu[card.menu] {
            cards.removeAll { $0.id == card.id }
            cardsByMenu[card.menu] = cards
        }
        
        // Add to Deleted menu
        let deletedCard = Card(id: card.id, name: card.name, menu: .deleted, created: card.created)
        cardsByMenu[.deleted, default: []].append(deletedCard)
    }
    
    /// Saves all cards to UserDefaults for persistence.
    private func saveCards() {
        let storage = CardStorage(cardsByMenu: mapKeys(cardsByMenu) { $0.rawValue })
        if let data = try? JSONEncoder().encode(storage) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    /// Loads cards from UserDefaults, including migration from old format if needed.
    private func loadCards() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            if let storage = try? JSONDecoder().decode(CardStorage.self, from: data) {
                cardsByMenu = Dictionary(uniqueKeysWithValues: storage.cardsByMenu.compactMap { key, cards in
                    guard let menu = Menu(rawValue: key) else { return nil }
                    return (menu, cards)
                })
            } else {
                // Migration path from old format [Menu.RawValue: [String]]
                if let oldStorage = try? JSONDecoder().decode(CardStorageOld.self, from: data) {
                    var migrated: [Menu: [Card]] = [:]
                    for (key, names) in oldStorage.cardsByMenu {
                        if let menu = Menu(rawValue: key) {
                            let cards = names.map { name in
                                Card(id: UUID(), name: name, menu: menu, created: Date())
                            }
                            migrated[menu] = cards
                        }
                    }
                    cardsByMenu = migrated
                }
            }
        }
    }
    
    /// Helper to map keys of a dictionary to a new type.
    private func mapKeys<K1: Hashable, K2: Hashable, V>(_ dict: [K1: V], _ transform: (K1) -> K2) -> [K2: V] {
        Dictionary(uniqueKeysWithValues: dict.map { (transform($0.key), $0.value) })
    }
    
    // MARK: - Main View
    var body: some View {
        ZStack(alignment: .top) {
            // Background color
            Color.customBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                glassNavBar // Top navigation bar (see below)
                menuList   // Menu list (see below)
                Spacer()
            }
        }
        .onAppear {
            loadCards() // Load cards on launch
        }
        .onChange(of: cardsByMenu) {
            saveCards() // Save cards whenever they change
        }
        // Presents the appropriate menu sheet as a full screen cover
        .fullScreenCover(item: $selectedMenu) { menu in
            Group {
                switch menu {
                case .todo:
                    // ToDoMenuSheet is defined in Views/MenuSheets/ToDoMenuSheet.swift
                    ToDoMenuSheet(menu: menu, cardsByMenu: $cardsByMenu, showAddSheet: $showAddSheet, newCardName: $newCardName, onSubmit: { menu, name in
                        let newCard = Card(id: UUID(), name: name, menu: menu, created: Date())
                        cardsByMenu[menu, default: []].append(newCard)
                    }, onDelete: moveCardToDeleted)
                case .shopping:
                    // ShoppingListMenuSheet is defined in Views/MenuSheets/ShoppingListMenuSheet.swift
                    ShoppingListMenuSheet(menu: menu, cardsByMenu: $cardsByMenu, showAddSheet: $showAddSheet, newCardName: $newCardName, onSubmit: { menu, name in
                        let newCard = Card(id: UUID(), name: name, menu: menu, created: Date())
                        cardsByMenu[menu, default: []].append(newCard)
                    }, onDelete: moveCardToDeleted)
                case .reminders:
                    // RemindersMenuSheet is defined in Views/MenuSheets/RemindersMenuSheet.swift
                    RemindersMenuSheet(menu: menu, cardsByMenu: $cardsByMenu, showAddSheet: $showAddSheet, newCardName: $newCardName, onSubmit: { menu, name in
                        let newCard = Card(id: UUID(), name: name, menu: menu, created: Date())
                        cardsByMenu[menu, default: []].append(newCard)
                    }, onDelete: moveCardToDeleted)
                case .notes:
                    // NotesMenuSheet is defined in Views/MenuSheets/NotesMenuSheet.swift
                    NotesMenuSheet(menu: menu, cardsByMenu: $cardsByMenu, showAddSheet: $showAddSheet, newCardName: $newCardName, onSubmit: { menu, name in
                        let newCard = Card(id: UUID(), name: name, menu: menu, created: Date())
                        cardsByMenu[menu, default: []].append(newCard)
                    }, onDelete: moveCardToDeleted)
                case .deleted:
                    // DeletedMenuSheet is defined in Views/MenuSheets/DeletedMenuSheet.swift
                    DeletedMenuSheet(menu: menu, cardsByMenu: $cardsByMenu, showAddSheet: $showAddSheet, newCardName: $newCardName, onSubmit: { menu, name in
                        let newCard = Card(id: UUID(), name: name, menu: menu, created: Date())
                        cardsByMenu[menu, default: []].append(newCard)
                    }, onDelete: moveCardToDeleted)
                }
            }
        }
        // Fallback fullScreenCover for add sheet (not used)
        .fullScreenCover(isPresented: $showAddSheet) {
            EmptyView()
        }
    }
    
    // MARK: - Glassmorphic Nav Bar
    /// The top navigation bar with glassmorphism effect.
    private var glassNavBar: some View {
        VStack(spacing: 0) {
            HStack {
                // Placeholder for symmetry
                Image(systemName: "folder.badge.plus")
                    .opacity(0)
                    .padding(.leading, 20)
                
                Spacer()
                Text("Smart List Manager")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                // Folder button (currently no action)
                Button(action: { /* Folder action */ }) {
                    Image(systemName: "folder.badge.plus")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.trailing, 20)
                }
            }
            .frame(height: 70)
            Divider().frame(height: 1).background(Color.secondary.opacity(0.25))
        }
    }
    
    // MARK: - Menu List (Non-scrollable)
    /// The main menu list with icons and counts for each menu type.
    private var menuList: some View {
        VStack(spacing: 16) {
            ForEach(Menu.allCases) { menu in
                Button(action: {
                    selectedMenu = menu
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: menu.icon)
                            .font(.title2)
                            .foregroundColor(MenuColors.color(for: menu))
                            .frame(width: 32, height: 32)
                        Text(menu.rawValue)
                            .font(.title3)
                            .foregroundColor(.primary)
                        Spacer()
                        // Show card count for each menu
                        Text("\(cardsByMenu[menu]?.count ?? 0)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 4)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.customSecondaryBackground)
                    .cornerRadius(16)
                    .customShadow()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 20)
    }
}

// MARK: - VisualEffectBlur for Glassmorphism
/// UIViewRepresentable wrapper for UIVisualEffectView to achieve glassmorphism blur effect.
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
