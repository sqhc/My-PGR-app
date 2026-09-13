import Foundation

/// Reads the bundled reference data.
///
/// The catalogue is read-only and ships with the app, so the decoded result is
/// cached in memory. Before this type existed each list screen re-read and
/// re-decoded the JSON on the main thread every time it appeared.
final class GameDataRepository {

    /// Repository used by the app. Tests may substitute one reading from a
    /// different bundle, or clear the cache between cases.
    static var shared = GameDataRepository()

    private let bundle: Bundle

    /// Outer optional: whether a load has happened. Inner: what it produced.
    /// A failure is cached as well, because a missing resource will not become
    /// available while the app runs.
    private var cached: GameData??

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    /// Decoded catalogue, or `nil` when the resource is missing or malformed.
    func load() -> GameData? {
        if let cached { return cached }

        let decoded = readFromBundle()
        cached = decoded
        if decoded == nil {
            print("GameData.json could not be decoded from bundle \(bundle.bundlePath)")
        }
        return decoded
    }

    private func readFromBundle() -> GameData? {
        guard let url = bundle.url(forResource: "GameData", withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(GameData.self, from: data)
        } catch {
            print("Error loading game data: \(error)")
            return nil
        }
    }
}
