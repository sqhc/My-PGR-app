import Foundation

struct GameData: Codable {
    let attribution: Attribution?
    let characters: [Character]
    let organizations: [Organization]
}

struct Attribution: Codable {
    let en: String
    let zh: String
}

struct Character: Codable {
    let name: String
    let nameZh: String
    let image: String
    let elementType: String
    let elementTypeZh: String
    let frameType: String
    let frameTypeZh: String
    let organization: String
    let organizationZh: String
    let description: Description
}

struct Description: Codable {
    let en: String
    let zh: String
}

struct Organization: Codable {
    let name: String
    let nameZh: String
    let image: String
    let description: Description
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
