import Foundation
import SwiftUI
import Combine

/// Manager responsible for app-wide state and lifecycle events
@MainActor
class AppManager: ObservableObject {
    static let shared = AppManager()
    
    @Published var isFirstLaunch: Bool = false
    @Published var appVersion: String = ""
    @Published var buildNumber: String = ""
    @Published var isAppActive: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "is_first_launch"
    
    private init() {
        setupApp()
        checkFirstLaunch()
    }
    
    // MARK: - Setup
    
    private func setupApp() {
        appVersion = Constants.App.version
        buildNumber = Constants.App.buildNumber
        
        // Setup app lifecycle observers
        setupAppLifecycleObservers()
    }
    
    private func checkFirstLaunch() {
        if !userDefaults.bool(forKey: firstLaunchKey) {
            isFirstLaunch = true
            userDefaults.set(true, forKey: firstLaunchKey)
        }
    }
    
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isAppActive = true
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.isAppActive = false
        }
    }
    
    // MARK: - Public Methods
    
    /// Resets the app to first launch state (useful for testing)
    func resetToFirstLaunch() {
        userDefaults.removeObject(forKey: firstLaunchKey)
        isFirstLaunch = true
    }
    
    /// Gets the full app version string
    var fullVersionString: String {
        return "\(appVersion) (\(buildNumber))"
    }
} 