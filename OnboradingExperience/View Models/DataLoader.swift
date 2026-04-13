import Foundation

struct GameData: Codable {
    let characters: [Character]
    let organizations: [Organization]
}

struct Character: Codable {
    let name: String
    let image: String
    let description: [String: String]
}

struct Organization: Codable {
    let name: String
    let image: String
    let description: [String: String]
}

class DataLoader {
    static let shared = DataLoader()
    private init() {}

    func loadGameData() -> GameData? {
        if let url = Bundle.main.url(forResource: "GameData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let gameData = try decoder.decode(GameData.self, from: data)
                return gameData
            } catch {
                print("Error loading game data: \(error)")
            }
        }
        return nil
    }
}
