//
//  ViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/5/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModels: [CollectionTableViewModel] = [
        CollectionTableViewModel(
            viewModels: [
                TileCollectionViewCellViewModel(title: "Characters", backgroundColor: .red),
                TileCollectionViewCellViewModel(title: "Organizations", backgroundColor: .cyan),
                TileCollectionViewCellViewModel(title: "Items&Concepts", backgroundColor: .blue),
                TileCollectionViewCellViewModel(title: "Developers", backgroundColor: .black)
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser(){
            // show onboarding
            let vc = storyboard?.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        guard let url = URL(string: "https://downloads.khinsider.com/game-soundtracks/album/punishing-gray-raven-original-soundtrack-vol.1/2-16%2520Normal%2520Life.mp3") else{
//            print("Can't play music")
//            return
//        }
//        let item = AVPlayerItem(url: url)
//        let player = AVPlayer(playerItem: item)
//        player.play()
//    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource, CollectionTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else{
            fatalError()
        }
        cell.congfigure(with: viewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.width/2
    }
    
    //MARK: -delegate
    func DidTapItem(with viewModel: TileCollectionViewCellViewModel){
        switch viewModel.title{
        case "Characters":
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Characters") as? CharactersViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "Organizations":
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Organizations") as? OrganizationsViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "Items&Concepts":
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Items&Concepts"){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "Developers":
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Developers"){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            fatalError()
        }
    }
}

class Core{
    static let shared = Core()
    
    func isNewUser()-> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
