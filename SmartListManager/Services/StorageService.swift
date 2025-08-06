import Foundation

/// Protocol defining storage service requirements
protocol StorageServiceProtocol {
    func saveItems(_ items: [Item]) async throws
    func loadItems() async throws -> [Item]
}

/// Service responsible for persisting and retrieving items
class StorageService: StorageServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "saved_items"
    
    func saveItems(_ items: [Item]) async throws {
        do {
            let data = try JSONEncoder().encode(items)
            userDefaults.set(data, forKey: itemsKey)
        } catch {
            throw StorageError.encodingFailed(error)
        }
    }
    
    func loadItems() async throws -> [Item] {
        guard let data = userDefaults.data(forKey: itemsKey) else {
            return []
        }
        
        do {
            let items = try JSONDecoder().decode([Item].self, from: data)
            return items
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Failed to encode items: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode items: \(error.localizedDescription)"
        }
    }
} 