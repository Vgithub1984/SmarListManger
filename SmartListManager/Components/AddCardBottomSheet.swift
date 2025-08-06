//
//  AddCardBottomSheet.swift
//  SmartListManager
//
//  A reusable bottom sheet for adding a new card to any menu.
//  Used by all menu sheets (see Views/MenuSheets/*.swift).
//
//  Created by Varun Patel on 8/5/25.
//

import SwiftUI

/// A bottom sheet view for adding a new card to a menu.
/// The onSubmit closure is provided by the parent menu sheet (see Views/MenuSheets/*.swift).
struct AddCardBottomSheet: View {
    @Binding var showSheet: Bool // Controls sheet visibility (bound from parent)
    let menu: ContentView.Menu   // The menu to which the card will be added
    @Binding var newCardName: String // The name input for the new card
    let onSubmit: (ContentView.Menu, String) -> Void // Called when user submits
    
    @FocusState private var isTextFieldFocused: Bool // Manages keyboard focus
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                Color.white.ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer().frame(height: 38)
                    // Title
                    Text("Create New \(menu.rawValue)")
                        .font(.headline)
                        .padding(.bottom, 12)
                    
                    // Text field for card name
                    ZStack(alignment: .trailing) {
                        TextField("Enter the name", text: $newCardName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .focused($isTextFieldFocused)
                        // Clear button for text field
                        if !newCardName.isEmpty {
                            Button(action: {
                                newCardName = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 34) // Align with text field edge
                            }
                        }
                    }
                    
                    // OK button to submit new card
                    Button("OK") {
                        if !newCardName.isEmpty {
                            onSubmit(menu, newCardName) // Calls closure from parent
                            newCardName = ""
                            showSheet = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newCardName.isEmpty)
                    
                    Spacer()
                }
                .frame(maxWidth: 440)
                .padding(.vertical, 24)
                
                // Close button (top right)
                Button(action: {
                    showSheet = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .presentationDetents([.medium]) // Medium-sized sheet
        .presentationDragIndicator(.visible)
        .onAppear {
            // Focus the text field when the sheet appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
    }
}

#Preview {
    AddCardBottomSheet(
        showSheet: .constant(true),
        menu: .todo,
        newCardName: .constant(""),
        onSubmit: { _, _ in }
    )
} 