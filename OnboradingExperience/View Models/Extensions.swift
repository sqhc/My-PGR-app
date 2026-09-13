import Foundation

extension Notification.Name {
    /// Broadcast after the reader's language preference changes.
    static let languageChanged = Notification.Name("languageChanged")
}

/// The two languages the reference material is published in.
enum AppLanguage: String, CaseIterable {
    case english = "en"
    case chinese = "zh"

    /// Display name shown in the language menu.
    var displayName: String {
        switch self {
        case .english: return "English"
        case .chinese: return "Chinese"
        }
    }
}

/// Single owner of the reader's language preference.
///
/// The choice is persisted in `UserDefaults` and announced through
/// `Notification.Name.languageChanged` so every visible screen can re-read it.
/// Without a stored choice the language follows the device's preferred
/// language, which is what the app did before this type existed.
enum LanguageController {

    static let defaultsKey = "selectedLanguage"

    /// Language currently in effect.
    static var current: AppLanguage {
        if let stored = UserDefaults.standard.string(forKey: defaultsKey),
           let language = AppLanguage(rawValue: stored) {
            return language
        }
        return devicePreferredLanguage
    }

    /// Persists `language` and notifies observers.
    static func set(_ language: AppLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: defaultsKey)
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }

    private static var devicePreferredLanguage: AppLanguage {
        let code = Locale.preferredLanguages.first?
            .split(separator: "-")
            .first
            .map(String.init)
        return code.flatMap(AppLanguage.init(rawValue:)) ?? .english
    }
}

/// Reader-facing text that exists in both published languages.
///
/// Reference material is bilingual, but both halves are optional: an item may
/// be published in one language only. Resolution always falls back to the
/// other language, and finally to an empty string, so a half-translated item
/// renders its available half instead of failing.
protocol BilingualText {
    var textEn: String { get }
    var textZh: String? { get }

    /// Text for `language`, falling back to the other language.
    func text(for language: AppLanguage) -> String
}

extension BilingualText {
    func text(for language: AppLanguage) -> String {
        switch language {
        case .english:
            return textEn.isEmpty ? (textZh ?? "") : textEn
        case .chinese:
            if let textZh, !textZh.isEmpty { return textZh }
            return textEn
        }
    }

    /// Text for whatever language is currently in effect.
    var currentText: String { text(for: LanguageController.current) }
}

/// Whether the reader has already seen the onboarding sequence.
///
/// This is the only piece of app state that outlives a launch, so it lives
/// here rather than inside the home screen that happens to read it first.
enum Core {
    private static let defaultsKey = "isNewUser"

    /// `true` until the reader finishes the onboarding sequence.
    static func isNewUser() -> Bool {
        !UserDefaults.standard.bool(forKey: defaultsKey)
    }

    /// Marks onboarding as seen.
    static func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: defaultsKey)
    }

    /// Marks onboarding as unseen, so it shows again on the next launch and can
    /// be replayed immediately from the home screen.
    static func resetNewUser() {
        UserDefaults.standard.set(false, forKey: defaultsKey)
    }
}
