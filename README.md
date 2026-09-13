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
│   │   ├── ViewController.swift                 # Home tiles + onboarding gate
│   │   ├── CollectionTableViewCell.swift        # Horizontal tile strip
│   │   ├── TileCollectionViewCell.swift         # Single tile
│   │   ├── WelcomeViewController.swift          # 5-page onboarding
│   │   ├── LocalizedListViewController.swift    # Shared list-screen behaviour
│   │   ├── CharactersViewController.swift       # Character list view
│   │   ├── OrganizationsViewController.swift    # Organization list view
│   │   ├── CharacterTableViewCell.swift         # Custom character cell
│   │   └── OrganizationTableViewCell.swift      # Custom organization cell
│   ├── View Models/
│   │   ├── GameDataRepository.swift             # Reads + caches GameData.json
│   │   ├── DataLoader.swift                     # Models and legacy access point
│   │   ├── Extensions.swift                     # Language, bilingual text, onboarding flag
│   │   ├── CollectionTableViewCellViewModel.swift
│   │   └── TileCollectionViewCellViewModel.swift
│   ├── Resources/
│   │   └── GameData.json                        # Character and organization data
│   ├── Assets.xcassets/                         # App images and icons
│   ├── Fonts/                                   # Custom fonts (Rajdhani)
│   ├── AppDelegate.swift                        # App lifecycle management
│   ├── SceneDelegate.swift                      # Scene configuration
│   └── Info.plist                               # App configuration
├── Scripts/build_imagesets.py                   # Generates imagesets from dropped art
├── _incoming_images/                            # Staging area for new artwork
├── docs/android-todo.md                         # Known Android-side work
├── CONTEXT.md                                   # Domain glossary
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

The app uses a JSON-based data model. `image` is the **catalogue key**: it must equal
the imageset name and the file name (see [Adding artwork](#adding-artwork)).

```json
{
  "attribution": { "en": "…", "zh": "…" },
  "characters": [
    {
      "name": "Lucia: Orion",
      "nameZh": "露西亚：红莲",
      "image": "LuciaOrion",
      "elementType": "Physical",
      "elementTypeZh": "物理",
      "frameType": "Rapid",
      "frameTypeZh": "突撃型",
      "organization": "Gray Raven",
      "organizationZh": "灰鸦小队",
      "description": { "en": "…", "zh": "…" }
    }
  ],
  "organizations": [
    {
      "name": "Gray Raven",
      "nameZh": "灰鸦小队",
      "image": "GrayRaven",
      "description": { "en": "…", "zh": "…" }
    }
  ]
}
```

Names and the other metadata fields are bilingual too. Any `…Zh` field may be omitted;
the app falls back to the English text rather than showing an empty label.

## Adding artwork

An item's `image` value, its `.imageset` name, and its file name are the same string.
To add or replace art:

1. Drop the file into `_incoming_images/`, named after the `image` value
   (e.g. `LuciaOrion.png`).
2. Run `python3 Scripts/build_imagesets.py` — it generates the imageset plus its
   `Contents.json`, and reports which keys are still outstanding.
3. Confirm the new imageset is included in `Assets.xcassets` in Xcode, then run the
   unit tests: `testEveryCatalogueImageResolves` fails if any catalogue key has no art.

A missing imageset is not a crash: the row shows a placeholder and logs the key.


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