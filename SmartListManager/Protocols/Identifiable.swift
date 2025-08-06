import Foundation

// MARK: - Custom Protocols
/// Custom protocol for objects that can be uniquely identified
protocol CustomIdentifiable {
    var id: UUID { get }
}

/// Custom protocol for objects that can be encoded and decoded
protocol CustomCodable {
    func encode() throws -> Data
    static func decode(from data: Data) throws -> Self
}

/// Custom protocol for objects that can be compared for equality
protocol CustomEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool
}

/// Custom protocol for objects that can be hashed
protocol CustomHashable {
    func hash(into hasher: inout Hasher)
}

/// Custom protocol for objects that can be observed for changes
protocol CustomObservable: AnyObject {
    var observers: [String: () -> Void] { get set }
    
    func addObserver(_ observer: @escaping () -> Void, forKey key: String)
    func removeObserver(forKey key: String)
    func notifyObservers()
}

// MARK: - Default Implementations
extension CustomObservable {
    func addObserver(_ observer: @escaping () -> Void, forKey key: String) {
        observers[key] = observer
    }
    
    func removeObserver(forKey key: String) {
        observers.removeValue(forKey: key)
    }
    
    func notifyObservers() {
        observers.values.forEach { $0() }
    }
} 