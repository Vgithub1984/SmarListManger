# Smart List Manager - iOS Project Structure

This document outlines the folder structure and organization of the Smart List Manager iOS app.

## 📁 Project Structure

```
SmartListManager/
├── SmartListManager/
│   ├── SmartListManagerApp.swift          # App entry point
│   ├── Views/                             # SwiftUI Views
│   │   ├── ContentView.swift             # Main content view
│   │   └── [Other view files...]
│   ├── ViewModels/                        # MVVM ViewModels
│   │   ├── ItemListViewModel.swift       # Main list view model
│   │   └── [Other view model files...]
│   ├── Models/                            # Data Models
│   │   ├── Item.swift                    # Item data model
│   │   └── [Other model files...]
│   ├── Services/                          # Business Logic & API Services
│   │   ├── StorageService.swift          # Data persistence service
│   │   └── [Other service files...]
│   ├── Components/                        # Reusable UI Components
│   │   ├── ItemRowView.swift             # Individual item row component
│   │   └── [Other component files...]
│   ├── Managers/                          # App-wide Managers
│   │   ├── AppManager.swift              # App lifecycle manager
│   │   └── [Other manager files...]
│   ├── Utils/                             # Utilities & Constants
│   │   ├── Constants.swift               # App constants
│   │   └── [Other utility files...]
│   ├── Extensions/                        # Swift Extensions
│   │   ├── View+Extensions.swift         # SwiftUI view extensions
│   │   └── [Other extension files...]
│   ├── Protocols/                         # Protocol Definitions
│   │   ├── Identifiable.swift            # Common protocols
│   │   └── [Other protocol files...]
│   ├── Resources/                         # Resources & Documentation
│   │   ├── README.md                     # This file
│   │   └── [Other resource files...]
│   └── Assets.xcassets/                   # App Assets
│       ├── AppIcon.appiconset/
│       ├── AccentColor.colorset/
│       └── Contents.json
└── SmartListManager.xcodeproj/            # Xcode Project
```

## 🏗️ Architecture Overview

This project follows the **MVVM (Model-View-ViewModel)** architecture pattern with additional organizational layers:

### Core Layers:
- **Views**: SwiftUI views that handle UI presentation
- **ViewModels**: Business logic and state management
- **Models**: Data structures and entities
- **Services**: External dependencies and data operations

### Supporting Layers:
- **Components**: Reusable UI components
- **Managers**: App-wide state and lifecycle management
- **Utils**: Constants, helpers, and utilities
- **Extensions**: Swift language extensions
- **Protocols**: Common protocol definitions

## 📋 Naming Conventions

### Files:
- **Views**: `[Name]View.swift` (e.g., `ContentView.swift`)
- **ViewModels**: `[Name]ViewModel.swift` (e.g., `ItemListViewModel.swift`)
- **Models**: `[Name].swift` (e.g., `Item.swift`)
- **Services**: `[Name]Service.swift` (e.g., `StorageService.swift`)
- **Components**: `[Name]View.swift` (e.g., `ItemRowView.swift`)
- **Managers**: `[Name]Manager.swift` (e.g., `AppManager.swift`)
- **Extensions**: `[Type]+[Purpose].swift` (e.g., `View+Extensions.swift`)

### Classes/Structs:
- **Views**: `[Name]View`
- **ViewModels**: `[Name]ViewModel`
- **Models**: `[Name]`
- **Services**: `[Name]Service`
- **Managers**: `[Name]Manager`

## 🔧 Best Practices

1. **Separation of Concerns**: Each file has a single responsibility
2. **Dependency Injection**: Services are injected into ViewModels
3. **Protocol-Oriented Programming**: Use protocols for abstraction
4. **Error Handling**: Proper error handling with custom error types
5. **Documentation**: Comprehensive documentation for public APIs
6. **Testing**: Structure supports unit testing and UI testing

## 🚀 Getting Started

1. Open `SmartListManager.xcodeproj` in Xcode
2. Build and run the project
3. The app will show a list manager interface
4. Add, toggle, and delete items as needed

## 📱 Features

- ✅ Add new items to the list
- ✅ Toggle item completion status
- ✅ Delete items from the list
- ✅ Persistent storage using UserDefaults
- ✅ Error handling and user feedback
- ✅ Modern SwiftUI interface
- ✅ MVVM architecture

## 🔄 Future Enhancements

This structure supports easy addition of:
- Cloud synchronization
- Categories and tags
- Search functionality
- Sorting and filtering
- Dark mode support
- Accessibility features
- Unit tests and UI tests
- Localization
- Push notifications

## 📚 Dependencies

- **SwiftUI**: Modern declarative UI framework
- **Foundation**: Core iOS framework
- **UserDefaults**: Local data persistence

## 🤝 Contributing

When adding new features:
1. Follow the existing folder structure
2. Use appropriate naming conventions
3. Add documentation for public APIs
4. Consider testability in your design
5. Update this README if adding new folders 