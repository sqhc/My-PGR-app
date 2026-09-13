import Foundation

// MARK: - Catalogue

/// Everything the reference screens display, decoded from `GameData.json`.
struct GameData: Codable {
    let attribution: Attribution?
    let characters: [Character]
    let organizations: [Organization]
}

struct Attribution: Codable {
    let en: String
    let zh: String?
}

// MARK: - Items

struct Character: Codable {
    let name: String
    let nameZh: String?
    let image: String
    let elementType: String
    let elementTypeZh: String?
    let frameType: String
    let frameTypeZh: String?
    let organization: String
    let organizationZh: String?
    let description: Description
}

struct Organization: Codable {
    let name: String
    let nameZh: String?
    let image: String
    let description: Description
}

struct Description: Codable {
    let en: String
    let zh: String?
}

// MARK: - Bilingual fields

// These conformances carry no storage; they expose the stored `…`/`…Zh` pair
// through the single `BilingualText` contract so a screen does not have to
// remember which field style an item uses.

extension Description: BilingualText {
    var textEn: String { en }
    var textZh: String? { zh }
}

extension Character {
    /// Display name in the reader's language.
    var localizedName: String {
        BilingualPair(english: name, chinese: nameZh).currentText
    }

    /// e.g. Physical / 物理.
    var localizedElementType: String {
        BilingualPair(english: elementType, chinese: elementTypeZh).currentText
    }

    /// e.g. Rapid / 突撃型.
    var localizedFrameType: String {
        BilingualPair(english: frameType, chinese: frameTypeZh).currentText
    }

    /// e.g. Gray Raven / 灰鸦小队.
    var localizedOrganization: String {
        BilingualPair(english: organization, chinese: organizationZh).currentText
    }

    /// Item blurb in the reader's language.
    var localizedDescription: String { description.currentText }
}

extension Organization {
    /// Display name in the reader's language.
    var localizedName: String {
        BilingualPair(english: name, chinese: nameZh).currentText
    }

    /// Item blurb in the reader's language.
    var localizedDescription: String { description.currentText }
}

/// Ad-hoc bilingual value for the inline `name` / `nameZh` field style.
struct BilingualPair: BilingualText {
    let english: String
    let chinese: String?

    var textEn: String { english }
    var textZh: String? { chinese }
}

// MARK: - Legacy access point

/// Retained so existing call sites keep working; delegates to the single
/// caching reader.
final class DataLoader {
    static let shared = DataLoader()
    private init() {}

    func loadGameData() -> GameData? {
        GameDataRepository.shared.load()
    }
}
