//
//  CharactersViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class CharactersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        return table
    }()
    
    private var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
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
            characters = gameData.characters
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
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
