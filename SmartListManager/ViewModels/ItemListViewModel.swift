import Foundation
import SwiftUI
import Combine

/// ViewModel responsible for managing the list of items
@MainActor
class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var newItemTitle: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
        loadItems()
    }
    
    // MARK: - Public Methods
    
    func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newItem = Item(title: newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines))
        items.append(newItem)
        newItemTitle = ""
        
        saveItems()
    }
    
    func toggleItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].toggleCompletion()
            saveItems()
        }
    }
    
    func deleteItem(_ item: Item) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }
    
    // MARK: - Private Methods
    
    private func loadItems() {
        isLoading = true
        Task {
            do {
                items = try await storageService.loadItems()
            } catch {
                errorMessage = "Failed to load items: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
    
    private func saveItems() {
        Task {
            do {
                try await storageService.saveItems(items)
            } catch {
                errorMessage = "Failed to save items: \(error.localizedDescription)"
            }
        }
    }
} 