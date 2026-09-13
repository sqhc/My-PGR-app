//
//  ViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/5/23.
//

import UIKit

class ViewController: UIViewController {

    /// The home screen's single section of tiles.
    ///
    /// Tiles without a destination are shown but marked unavailable, so adding
    /// a section later is a one-line change instead of a new crash path.
    private var sections: [CollectionTableViewModel] {
        [
            CollectionTableViewModel(viewModels: [
                TileCollectionViewCellViewModel(
                    title: "Characters",
                    backgroundColor: .red,
                    destinationIdentifier: StoryboardDestination.characters
                ),
                TileCollectionViewCellViewModel(
                    title: "Organizations",
                    backgroundColor: .cyan,
                    destinationIdentifier: StoryboardDestination.organizations
                ),
                TileCollectionViewCellViewModel(
                    title: "Items&Concepts",
                    backgroundColor: .blue
                ),
                TileCollectionViewCellViewModel(
                    title: "Developers",
                    backgroundColor: .black
                )
            ])
        ]
    }

    /// Icon taps needed before the onboarding sequence is replayed. A single
    /// tap already opens the App Store, so replaying uses repeated taps.
    private static let tapsToReplayOnboarding = 3

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appIconImage: UIImageView!

    private var iconTapCount = 0
    private var hasPresentedOnboarding = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)

        // The home content is in English only, so it restates the language menu
        // rather than the app's current language.
        title = "Punishing: Gray Raven"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(replayOnboarding)
        )
        navigationController?.navigationBar.tintColor = .white

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleIconTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        appIconImage.isUserInteractionEnabled = true
        appIconImage.addGestureRecognizer(recognizer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presentOnboardingIfNeeded()
    }

    // MARK: - Onboarding

    /// Shows the onboarding sequence on first launch.
    ///
    /// Guarded: `viewDidLayoutSubviews` runs again when this screen is
    /// uncovered, and onboarding must not reappear after being dismissed.
    private func presentOnboardingIfNeeded() {
        guard !hasPresentedOnboarding, Core.isNewUser() else { return }
        hasPresentedOnboarding = true
        presentOnboarding()
    }

    private func presentOnboarding() {
        guard let welcome = storyboard?.instantiateViewController(
            withIdentifier: StoryboardDestination.welcome
        ) else {
            print("Storyboard is missing the \"\(StoryboardDestination.welcome)\" scene")
            return
        }
        welcome.modalPresentationStyle = .fullScreen
        present(welcome, animated: true)
    }

    /// Replays onboarding without deleting the app.
    @objc private func replayOnboarding() {
        Core.resetNewUser()
        presentOnboarding()
    }

    // MARK: - App Store link

    @objc private func handleIconTap(_ gesture: UITapGestureRecognizer) {
        iconTapCount += 1
        if iconTapCount >= Self.tapsToReplayOnboarding {
            iconTapCount = 0
            replayOnboarding()
            return
        }
        openAppStore()
    }

    private func openAppStore() {
        guard let url = URL(string: "https://apps.apple.com/us/app/punishing-gray-raven/id1571685286") else {
            presentAppStoreError()
            return
        }
        UIApplication.shared.open(url)
    }

    private func presentAppStoreError() {
        let alert = UIAlertController(
            title: "Oops",
            message: "Not able to open App Store",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Navigation

    /// Opens the storyboard scene a tile points at.
    private func show(destination identifier: String) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) else {
            print("Storyboard is missing the \"\(identifier)\" scene")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CollectionTableViewCell.height(forWidth: tableView.bounds.size.width)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionTableViewCell.identifier,
            for: indexPath
        ) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: sections[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - CollectionTableViewCellDelegate

extension ViewController: CollectionTableViewCellDelegate {

    func didTapItem(with viewModel: TileCollectionViewCellViewModel) {
        guard let destination = viewModel.destinationIdentifier else {
            print("Tile \"\(viewModel.title)\" has no destination yet")
            return
        }
        show(destination: destination)
    }
}
