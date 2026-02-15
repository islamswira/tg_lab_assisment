# TG Lab NBA App - Homework Assignment

A simple NBA app built with SwiftUI.

## Features

- **Home Tab**: Browse all 30 NBA teams with logos, sortable by Name/City/Conference
- **Team Games**: Tap a team to view recent games with endless scroll pagination
- **Players Tab**: Search players by name with debounced search
- **Player → Team Games**: Tap any player to view their team's games
- **Sort Sheet**: Bottom sheet to change team list sort order

## Architecture

Clean Architecture with separation into layers:

```
Domain  → Entities, Repository protocols, UseCases
Data    → DTOs, Networking, Repository implementations
Present → SwiftUI Views + @Observable ViewModels
DI      → AppContainer (dependency composition)
```

## Tech Stack

- **SwiftUI** (iOS 17+)
- **@Observable** macro for state management
- **Kingfisher** (SPM) for team logo images
- **XcodeGen** for project generation
- **async/await** concurrency

## Data Source

The app calls the [balldontlie.io](https://app.balldontlie.io) API by default with an embedded API key.

To use bundled local JSON data instead (offline mode), add `USE_LOCAL_DATA` to your Xcode scheme launch arguments.

## Setup

1. Clone the repository
2. Run `xcodegen generate` to create the Xcode project
3. Open `TGLabNBA.xcodeproj` in Xcode
4. Build and run (Cmd+R)

## Testing

- **Unit Tests**: ViewModel + UseCase tests
- **UI Tests**: Uses `UI_TESTING` launch argument with stub data
- Run all tests with Cmd+U

## Project Generation

This project uses [XcodeGen](https://github.com/yonaskolb/XcodeGen). The `.xcodeproj` is gitignored — regenerate with:

```bash
xcodegen generate
```
