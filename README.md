# PGR Onboarding Experience

An iOS application that showcases character and organization information from the Punishing: Gray Raven universe. Built with Swift and UIKit.

## Features

- **Character Showcase**: Displays detailed character information including names, images, and descriptions
- **Organization Profiles**: Shows various organizations within the game's lore
- **Multi-language Support**: Bilingual interface supporting English and Chinese
- **Dynamic Content**: Pulls character and organization data from JSON files
- **Modern UI**: Uses UITableView with custom cell configurations for smooth scrolling experiences

## Tech Stack

- **Language**: Swift 5+
- **UI Framework**: UIKit
- **Architecture**: MVC (Model-View-Controller)
- **Data Management**: JSON-based data loading
- **Build Tool**: Xcode

## Project Structure

```
My-PGR-app/
├── OnboradingExperience/
│   ├── Views/
│   │   ├── CharactersViewController.swift       # Character list view
│   │   ├── OrganizationsViewController.swift    # Organization list view
│   │   ├── CharacterTableViewCell.swift        # Custom character cell
│   │   └── OrganizationTableViewCell.swift     # Custom organization cell
│   ├── View Models/
│   │   ├── DataLoader.swift                     # Data loading logic
│   │   └── Extensions.swift                     # Utility extensions
│   ├── Resources/
│   │   └── GameData.json                        # Character and organization data
│   ├── Assets.xcassets/                         # App images and icons
│   ├── Fonts/                                   # Custom fonts (Rajdhani)
│   ├── AppDelegate.swift                        # App lifecycle management
│   ├── SceneDelegate.swift                      # Scene configuration
│   └── Info.plist                               # App configuration
├── android/                                     # Android project files (optional)
└── README.md                                    # Project documentation
```

## Requirements

- iOS 13.0+
- Xcode 13.0+
- Swift 5.0+

## Setup

1. Open the project in Xcode
2. Ensure all dependencies are installed
3. Build and run the app on a simulator or device

## Data Structure

The app uses a JSON-based data model:

```json
{
  "characters": [
    {
      "name": "Lucia",
      "image": "Lucia1",
      "description": {
        "en": "English description",
        "zh": "Chinese description"
      }
    }
  ],
  "organizations": [
    {
      "name": "Organization Name",
      "image": "image_name",
      "description": {
        "en": "English description",
        "zh": "Chinese description"
      }
    }
  ]
}
```

## Language Support

The app supports two languages:
- **English** (en)
- **Chinese** (zh)

Language preference is saved to UserDefaults and persists across app sessions.

## Customization

- **Character Images**: Add images to `OnboradingExperience/Assets.xcassets/`
- **Game Data**: Modify `OnboradingExperience/Resources/GameData.json`
- **UI Styling**: Update navigation bar settings in view controllers

## License

This project is for educational purposes.

## Credits

Punishing: Gray Raven © 2022 KRAFTON. All rights reserved.

## Contributing

This is a personal project. Feel free to fork and use for your own purposes.