// DeletedMenuSheet.swift
// Displays the Deleted menu sheet with a list of deleted cards, add button, and permanent delete functionality.
// Called from ContentView.swift
//
// Permanent deletion uses the permanentlyDeleteCard function defined in this file.
//
// Created by [Your Name] on [Date].
//
//  Created by Varun Patel on 8/5/25.
//

import SwiftUI

struct DeletedMenuSheet: View {
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
    // The main body of the DeletedMenuSheet
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 0) {
                    // List of deleted cards, sorted from newest to oldest
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // ForEach displays each deleted card
                            // The onDelete closure calls permanentlyDeleteCard defined below
                            ForEach(cardsByMenu[menu]?.sorted(by: { $0.created > $1.created }) ?? [], id: \.id) { card in
                                CardRowView(card: card) {
                                    cardToDelete = card
                                    showDeleteConfirmation = true
                                }
                            }
                            // Show message if no deleted cards exist
                            if (cardsByMenu[menu]?.isEmpty ?? true) {
                                VStack(spacing: 8) {
                                    Image(systemName: "trash")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                    Text("No deleted items.")
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
                // Floating Add Button (disabled in Deleted menu)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddSheet = true
                        }) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(MenuColors.color(for: menu))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 32)
                        .disabled(true) // Add is disabled in Deleted menu
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
            // Permanent delete confirmation alert
            .alert(
                "Permanently Delete Item",
                isPresented: $showDeleteConfirmation,
                presenting: cardToDelete
            ) { card in
                Button("Cancel", role: .cancel) { }
                Button("Delete Permanently", role: .destructive) {
                    // Calls permanentlyDeleteCard defined below
                    permanentlyDeleteCard(card)
                }
            } message: { card in
                Text("Are you sure you want to permanently delete '\(card.name)'? This action cannot be undone.")
            }
            .frame(maxWidth: 400)
        }
        .sheet(isPresented: $showAddSheet) {
            AddCardBottomSheet(
                showSheet: $showAddSheet,
                menu: menu,
                newCardName: $newCardName,
                onSubmit: onSubmit
            )
        }
    }
    
    private func permanentlyDeleteCard(_ card: Card) {
        if var cards = cardsByMenu[menu] {
            cards.removeAll { $0.id == card.id }
            cardsByMenu[menu] = cards
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
    DeletedMenuSheet(
        menu: .deleted,
        cardsByMenu: .constant([.deleted: [Card(id: UUID(), name: "Sample Deleted Item", menu: .deleted, created: Date())]]),
        showAddSheet: .constant(false),
        newCardName: .constant(""),
        onSubmit: { _, _ in },
        onDelete: { _ in }
    )
} 