//
//  CharactersViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class CharactersViewController: LocalizedListViewController {

    private var characters: [Character] = []

    override var cellTypes: [UITableViewCell.Type] { [CharacterTableViewCell.self] }

    override func viewDidLoad() {
        title = "Characters"
        super.viewDidLoad()
        loadContent()
    }

    override func refreshList() {
        loadContent()
        super.refreshList()
    }

    private func loadContent() {
        characters = GameDataRepository.shared.load()?.characters ?? []
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }

    override func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? CharacterTableViewCell,
              characters.indices.contains(indexPath.row) else { return }
        cell.configure(with: characters[indexPath.row])
    }
}
