// ToDoMenuSheet.swift
// Displays the To Do menu sheet with a list of cards, add button, and delete functionality.
// Called from ContentView.swift
//
// Card deletion uses the moveCardToDeleted function defined in ContentView.swift
//
// Created by [Your Name] on [Date].
//
//  Created by Varun Patel on 8/5/25.
//

import SwiftUI

struct ToDoMenuSheet: View {
    let menu: ContentView.Menu
    @Binding var cardsByMenu: [ContentView.Menu: [Card]]
    @Binding var showAddSheet: Bool
    @Binding var newCardName: String
    let onSubmit: (ContentView.Menu, String) -> Void
    let onDelete: (Card) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var cardToDelete: Card? = nil
    @State private var showDeleteConfirmation = false
    
    // MARK: - Main View
    // The main body of the ToDoMenuSheet
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 0) {
                    // List of cards, sorted from newest to oldest
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // ForEach displays each card in the To Do menu
                            // The onDelete closure calls moveCardToDeleted from ContentView.swift
                            ForEach(cardsByMenu[menu]?.sorted(by: { $0.created > $1.created }) ?? [], id: \.id) { card in
                                CardRowView(card: card) {
                                    cardToDelete = card
                                    showDeleteConfirmation = true
                                }
                            }
                            // Show message if no cards exist
                            if (cardsByMenu[menu]?.isEmpty ?? true) {
                                VStack(spacing: 8) {
                                    Image(systemName: "tray")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                    Text("Tap the + button to add your first item")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 40)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                    Spacer()
                }
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(MenuColors.color(for: menu))
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            // Navigation bar with back button and menu title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(MenuColors.color(for: menu))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(menu.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            // Delete confirmation alert
            .alert(
                "Delete Item",
                isPresented: $showDeleteConfirmation,
                presenting: cardToDelete
            ) { card in
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    // Calls moveCardToDeleted from ContentView.swift
                    onDelete(card)
                }
            } message: { card in
                Text("Are you sure you want to delete '\(card.name)'? This item will be moved to the Deleted menu.")
            }
            .frame(maxWidth: 400)
            // Add Card Bottom Sheet
            .sheet(isPresented: $showAddSheet) {
                // AddCardBottomSheet is defined in Components/AddCardBottomSheet.swift
                AddCardBottomSheet(
                    showSheet: $showAddSheet,
                    menu: menu,
                    newCardName: $newCardName,
                    onSubmit: onSubmit
                )
            }
        }
    }
    

}

// MARK: - CardRowView
private struct CardRowView: View {
    let card: Card
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("Created: \(card.created.formatted(date: .abbreviated, time: .shortened))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    ToDoMenuSheet(
        menu: .todo,
        cardsByMenu: .constant([.todo: [Card(id: UUID(), name: "Sample To Do", menu: .todo, created: Date())]]),
        showAddSheet: .constant(false),
        newCardName: .constant(""),
        onSubmit: { _, _ in },
        onDelete: { _ in }
    )
} 