# Copilot Instructions for Event App

## Project Overview
This is a Flutter mobile app for "Salon national de l'éducation" - an educational event showcase. The app displays exhibitors, conferences, activities, and ambassadors with favorites functionality.

## Architecture Patterns

### Directory Structure
- `lib/screens/` - UI screens with `main_screen.dart` as navigation hub using drawer pattern
- `lib/models/` - Data models with `fromJson()` factory constructors for API parsing
- `lib/services/` - API service layer, primarily Wix CMS integration via `wix_service.dart`
- `lib/controllers/` - Business logic, notably `favorite_controller.dart` for local persistence
- `assets/images/` - Static images (note: `Acceuil.jpg` vs `Accueil.png` naming inconsistency)

### Navigation Pattern
Main navigation uses a Drawer with 7 screens accessed via `_selectedIndex` in `main_screen.dart`. Each list item closes drawer automatically with `Navigator.pop(context)`.

### Data Flow
1. Services fetch data from Wix CMS API using hardcoded credentials in `wix_service.dart`
2. Models parse JSON with `factory .fromJson()` pattern
3. Controllers manage local state (favorites stored as JSON files via `path_provider`)
4. Screens consume data through direct service calls (no state management beyond local state)

## Key Development Workflows

### Version Management
Version numbers are synchronized across:
- `pubspec.yaml`: `version: 3.0.4+10` (semantic+build)
- `android/app/build.gradle.kts`: `versionCode = 10`, `versionName = "3.0.4"`
- iOS: Managed through Xcode project settings

### Build Process
**Android Release:**
```bash
flutter clean
flutter build appbundle --release  # For Google Play Store
flutter build apk --release        # Alternative/backup
```

**iOS Release:**
```bash
flutter build ipa --release        # Requires Apple Developer signing
flutter build ios --release --no-codesign  # For unsigned builds
```

### Signing Configuration
- Android: Uses `key.properties` file with signing certificates
- iOS: Requires Apple Developer account setup in Xcode Signing & Capabilities

## Project-Specific Conventions

### API Integration
- Wix CMS is the primary data source with hardcoded API key in `wix_service.dart`
- Collections: "App exposants 2025", "Ambassadeurs", "Conférences", "Activités"
- Error handling is minimal - services don't implement retry logic

### Asset Management
- Images stored in `assets/images/` with French naming
- Launcher icons configured via `flutter_launcher_icons` package
- Asset paths referenced directly in code (e.g., `"assets/images/Acceuil.jpg"`)

### Favorites System
- Uses file-based persistence (`favorites.json` in app documents directory)
- Single list stores both exhibitor and activity favorites as strings
- No synchronization with backend - purely local storage

### UI Patterns
- Consistent white background: `scaffoldBackgroundColor: Colors.white` globally
- Material Design with blue primary color
- External URL launching via `url_launcher` package
- Loading states handled with `flutter_spinkit`
- Network images cached via `cached_network_image`

## Critical Dependencies
- `provider: ^6.1.2` - State management (currently underutilized)
- `http: ^0.13.6` - API communication
- `shared_preferences: ^2.2.3` - Simple key-value storage
- `url_launcher: ^6.0.20` - External URL handling

## Platform-Specific Notes
- Android: `applicationId = "com.felixservice.salonapprentissage"`
- iOS: Bundle identifier matches Android applicationId
- Both platforms target modern versions (iOS 13.0+, Android API level managed by Flutter)

## Development Environment Setup
Project supports both Windows (primary development) and macOS (iOS builds via MacinCloud). Flutter doctor should show clean setup for both platforms when building releases.