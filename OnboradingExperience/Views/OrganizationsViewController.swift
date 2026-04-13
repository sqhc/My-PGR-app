//
//  OrganizationsViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class OrganizationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(OrganizationTableViewCell.self, forCellReuseIdentifier: OrganizationTableViewCell.identifier)
        return table
    }()

    private var organizations: [Organization] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Organizations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showLanguageMenu))
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Rajdhani-Bold", size: 24)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        if let gameData = DataLoader.shared.loadGameData() {
            organizations = gameData.organizations
            tableView.reloadData()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }

    @objc private func languageDidChange() {
        tableView.reloadData()
    }

    @objc private func showLanguageMenu() {
        let alertController = UIAlertController(title: "Select Language", message: nil, preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: "English", style: .default) { _ in
            self.setLanguage(to: "en")
        }
        let chineseAction = UIAlertAction(title: "Chinese", style: .default) { _ in
            self.setLanguage(to: "zh")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(englishAction)
        alertController.addAction(chineseAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func setLanguage(to languageCode: String) {
        UserDefaults.standard.set(languageCode, forKey: "selectedLanguage")
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.identifier, for: indexPath) as? OrganizationTableViewCell else {
            return UITableViewCell()
        }
        let organization = organizations[indexPath.row]
        cell.configure(with: organization)
        return cell
    }
}
