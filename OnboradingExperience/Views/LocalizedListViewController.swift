import UIKit

/// Shared behaviour of the catalogue list screens (Characters, Organizations).
///
/// Those two screens differed only in which collection they show and how a
/// cell is filled, so everything else lives here: table view construction,
/// navigation-bar styling, the language menu, and the observer that re-renders
/// the list when the reader switches language.
///
/// - Note: no `deinit` cleanup is needed for the language observer. Since iOS 9
///   `NotificationCenter` holds observers weakly, so the controller can still
///   be released while registered. `refreshList()` also re-syncs on every
///   appearance, which is what actually keeps a screen consistent with the
///   language chosen on another screen.
class LocalizedListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /// The table backing the screen.
    let tableView = UITableView()

    /// Cell subclasses to register before dequeuing.
    var cellTypes: [UITableViewCell.Type] { [] }

    override func viewDidLoad() {
        super.viewDidLoad()

        cellTypes.forEach { tableView.register($0, forCellReuseIdentifier: $0.identifier) }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none

        view.backgroundColor = .black
        view.addSubview(tableView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(showLanguageMenu)
        )
        navigationController?.navigationBar.tintColor = .white

        if let font = UIFont(name: "Rajdhani-Bold", size: 24) {
            navigationController?.navigationBar.titleTextAttributes = [
                .font: font,
                .foregroundColor: UIColor.white
            ]
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: .languageChanged,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // The language may have changed while a different screen was on top.
        refreshList()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Content

    /// Re-reads the content and rebuilds the list.
    func refreshList() {
        tableView.reloadData()
    }

    /// Fills `cell` with the item at `indexPath`. Subclasses must override.
    func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {}

    /// Builds a cell from the displayed content. Subclasses where a cell class
    /// stands for a different item type override this.
    func makeCell(at indexPath: IndexPath) -> UITableViewCell {
        dequeueDefaultCell(at: indexPath)
    }

    /// Dequeues an instance of `cellTypes[indexPath.section]`.
    final func dequeueDefaultCell(at indexPath: IndexPath) -> UITableViewCell {
        let types = cellTypes
        guard types.indices.contains(indexPath.section) else {
            return UITableViewCell()
        }
        return tableView.dequeueReusableCell(
            withIdentifier: types[indexPath.section].identifier,
            for: indexPath
        )
    }

    // MARK: - Language

    @objc private func showLanguageMenu() {
        let alert = UIAlertController(
            title: "Select Language",
            message: nil,
            preferredStyle: .actionSheet
        )
        for language in AppLanguage.allCases {
            alert.addAction(UIAlertAction(title: language.displayName, style: .default) { _ in
                LanguageController.set(language)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func languageDidChange() {
        refreshList()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        cellTypes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(at: indexPath)
        configure(cell, at: indexPath)
        return cell
    }
}

/// Reuse identifiers derived from the class name.
///
/// UIKit registers and dequeues by string, and the two drifting apart is a
/// silent, hard-to-trace bug. Deriving the string from the type removes the
/// second source of truth.
extension UITableViewCell {
    class var identifier: String { String(describing: self) }
}

extension UICollectionViewCell {
    class var identifier: String { String(describing: self) }
}
