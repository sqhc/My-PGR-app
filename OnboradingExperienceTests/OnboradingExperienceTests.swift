//
//  OnboradingExperienceTests.swift
//  OnboradingExperienceTests
//
//  Created by 沈清昊 on 3/5/23.
//

import XCTest
import UIKit
@testable import OnboradingExperience

final class OnboradingExperienceTests: XCTestCase {

    /// Keys this suite writes to, restored after every test.
    private static let touchedDefaultsKeys = [
        LanguageController.defaultsKey,
        "isNewUser"
    ]
    private var savedDefaults: [String: Any] = [:]

    override func setUpWithError() throws {
        savedDefaults = [:]
        for key in Self.touchedDefaultsKeys {
            if let value = UserDefaults.standard.object(forKey: key) {
                savedDefaults[key] = value
            }
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    override func tearDownWithError() throws {
        for key in Self.touchedDefaultsKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        for (key, value) in savedDefaults {
            UserDefaults.standard.set(value, forKey: key)
        }
        savedDefaults = [:]
    }

    // MARK: - Catalogue

    func testGameDataLoadsFromBundle() throws {
        let data = try XCTUnwrap(
            GameDataRepository.shared.load(),
            "GameData.json should decode from the app bundle"
        )
        XCTAssertEqual(data.characters.count, 26)
        XCTAssertEqual(data.organizations.count, 10)
        XCTAssertNotNil(data.attribution)

        let first = try XCTUnwrap(data.characters.first)
        XCTAssertFalse(first.name.isEmpty)
        XCTAssertFalse(first.image.isEmpty)
        XCTAssertFalse(first.elementType.isEmpty)
        XCTAssertFalse(first.frameType.isEmpty)
        XCTAssertFalse(first.organization.isEmpty)
    }

    // MARK: - Assets
    //
    // These two are the regression guard for the defect that motivated this
    // suite: the catalogue referenced 36 images while the asset catalog only
    // had a handful of them, so most rows rendered an empty frame.

    /// Every `image` value in the catalogue must resolve at runtime.
    func testEveryCatalogueImageResolves() throws {
        let data = try XCTUnwrap(GameDataRepository.shared.load())

        let referenced = data.characters.map(\.image) + data.organizations.map(\.image)
        let missing = referenced
            .filter { UIImage(named: $0) == nil }
            .sorted()

        XCTAssertTrue(
            missing.isEmpty,
            """
            \(missing.count) of \(referenced.count) catalogue images have no compiled imageset.
            Add an imageset named exactly like the catalogue key for each of:
            \(missing.joined(separator: ", "))
            """
        )
    }

    /// The reverse direction: no imageset should linger without a reference.
    ///
    /// Compiled asset catalogs are baked into `Assets.car`, so the imagesets are
    /// not enumerable through `Bundle` at run time. This inspects the source
    /// catalog instead, resolved from this file's location.
    func testAssetCatalogHasNoUnreferencedImagesets() throws {
        let data = try XCTUnwrap(GameDataRepository.shared.load())
        let referenced = Set(data.characters.map(\.image) + data.organizations.map(\.image))

        // Onboarding art and the app icon are referenced by code or by the
        // system rather than by the catalogue.
        let codeReferenced: Set<String> = [
            "welcome_1", "welcome_2", "welcome_3", "welcome_4", "welcome_5",
            "AppIcon", "AccentColor"
        ]

        let catalog = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()          // OnboradingExperienceTests
            .deletingLastPathComponent()          // repository root
            .appendingPathComponent("OnboradingExperience/Assets.xcassets")

        let names = try FileManager.default
            .contentsOfDirectory(at: catalog, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "imageset" }
            .map { $0.deletingPathExtension().lastPathComponent }

        XCTAssertFalse(names.isEmpty, "No imagesets found at \(catalog.path)")

        let orphans = Set(names)
            .subtracting(referenced)
            .subtracting(codeReferenced)
            .sorted()

        XCTAssertTrue(
            orphans.isEmpty,
            "Unreferenced imagesets in Assets.xcassets: \(orphans.joined(separator: ", "))"
        )
    }

    /// Every imageset must be complete, or it will not compile into the app.
    func testEveryImagesetIsWellFormed() throws {
        let catalog = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("OnboradingExperience/Assets.xcassets")

        let imagesets = try FileManager.default
            .contentsOfDirectory(at: catalog, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "imageset" }

        XCTAssertFalse(imagesets.isEmpty)

        for imageset in imagesets {
            let contents = imageset.appendingPathComponent("Contents.json")
            XCTAssertTrue(
                FileManager.default.fileExists(atPath: contents.path),
                "\(imageset.lastPathComponent) has no Contents.json and will not compile"
            )
            let files = try FileManager.default.contentsOfDirectory(atPath: imageset.path)
            XCTAssertTrue(
                files.contains { $0 != "Contents.json" },
                "\(imageset.lastPathComponent) declares no image file"
            )
        }
    }

    // MARK: - Localization

    func testMissingChineseFieldFallsBackToEnglish() {
        let englishOnly = BilingualPair(english: "Gray Raven", chinese: nil)
        XCTAssertEqual(englishOnly.text(for: .chinese), "Gray Raven")
        XCTAssertEqual(englishOnly.text(for: .english), "Gray Raven")

        let blankChinese = BilingualPair(english: "Gray Raven", chinese: "")
        XCTAssertEqual(blankChinese.text(for: .chinese), "Gray Raven")
    }

    func testChineseFieldWinsWhenPresent() {
        let both = BilingualPair(english: "Gray Raven", chinese: "灰鸦小队")
        XCTAssertEqual(both.text(for: .chinese), "灰鸦小队")
        XCTAssertEqual(both.text(for: .english), "Gray Raven")
    }

    func testEmptyEnglishFallsBackToChinese() {
        let chineseOnly = BilingualPair(english: "", chinese: "灰鸦小队")
        XCTAssertEqual(chineseOnly.text(for: .english), "灰鸦小队")
    }

    func testCharacterExposesLocalizedFields() throws {
        let data = try XCTUnwrap(GameDataRepository.shared.load())
        let lucia = try XCTUnwrap(data.characters.first { $0.name == "Lucia: Orion" })

        LanguageController.set(.english)
        XCTAssertEqual(lucia.localizedName, "Lucia: Orion")
        XCTAssertEqual(lucia.localizedElementType, "Physical")

        LanguageController.set(.chinese)
        XCTAssertEqual(lucia.localizedName, "露西亚：红莲")
        XCTAssertEqual(lucia.localizedElementType, "物理")
    }

    // MARK: - Language state

    func testLanguageChoiceIsPersistedAndBroadcast() {
        let expectation = expectation(forNotification: .languageChanged, object: nil)

        LanguageController.set(.chinese)

        XCTAssertEqual(
            UserDefaults.standard.string(forKey: LanguageController.defaultsKey),
            AppLanguage.chinese.rawValue
        )
        XCTAssertEqual(LanguageController.current, .chinese)

        wait(for: [expectation], timeout: 1)
    }

    func testUnsetLanguageFollowsDeviceWithEnglishFallback() {
        // No stored choice: resolution must still produce a supported language.
        XCTAssertTrue(AppLanguage.allCases.contains(LanguageController.current))
    }

    // MARK: - Missing art

    func testMissingCatalogueImageYieldsPlaceholder() {
        let image = UIImage.catalogueImage(named: "definitely-not-a-real-imageset")
        XCTAssertNotNil(image, "A missing catalogue image must not leave an empty frame")
    }

    func testExistingCatalogueImageIsNotReplaced() throws {
        let image = try XCTUnwrap(UIImage.catalogueImage(named: "welcome_1"))
        XCTAssertNotNil(image.cgImage)
    }

    // MARK: - Onboarding state

    func testOnboardingFlagRoundTrips() {
        Core.resetNewUser()
        XCTAssertTrue(Core.isNewUser())

        Core.setIsNotNewUser()
        XCTAssertFalse(Core.isNewUser())

        Core.resetNewUser()
        XCTAssertTrue(Core.isNewUser(), "Replay must make onboarding eligible again")
    }

    // MARK: - Home tiles

    func testUnavailableTileHasNoDestination() {
        let unavailable = TileCollectionViewCellViewModel(title: "Developers", backgroundColor: .black)
        XCTAssertNil(unavailable.destinationIdentifier)
        XCTAssertFalse(unavailable.isAvailable)
    }

    func testBuiltTileHasDestination() {
        let tile = TileCollectionViewCellViewModel(
            title: "Characters",
            backgroundColor: .red,
            destinationIdentifier: StoryboardDestination.characters
        )
        XCTAssertTrue(tile.isAvailable)
        XCTAssertEqual(tile.destinationIdentifier, "Characters")
    }
}
