//
//  OrganizationsViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class OrganizationsViewController: LocalizedListViewController {

    private var organizations: [Organization] = []

    override var cellTypes: [UITableViewCell.Type] { [OrganizationTableViewCell.self] }

    override func viewDidLoad() {
        title = "Organizations"
        super.viewDidLoad()
        loadContent()
    }

    override func refreshList() {
        loadContent()
        super.refreshList()
    }

    private func loadContent() {
        organizations = GameDataRepository.shared.load()?.organizations ?? []
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organizations.count
    }

    override func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? OrganizationTableViewCell,
              organizations.indices.contains(indexPath.row) else { return }
        cell.configure(with: organizations[indexPath.row])
    }
}
