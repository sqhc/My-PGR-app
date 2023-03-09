//
//  OrganizationsViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class OrganizationsViewController: UIViewController {
    @IBOutlet weak var grayRavenImage: UIImageView!
    @IBOutlet weak var grayRavenTextView: UITextView!
    @IBOutlet weak var worldGovernmentImage: UIImageView!
    @IBOutlet weak var worldGovernmentTextView: UITextView!
    @IBOutlet weak var csuImage: UIImageView!
    @IBOutlet weak var csuTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showGrayRaven(_:)))
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 1
        grayRavenImage.isUserInteractionEnabled = true
        grayRavenImage.addGestureRecognizer(recognizer)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(showWorldGovernment(_:)))
        recognizer2.numberOfTouchesRequired = 1
        recognizer2.numberOfTapsRequired = 1
        worldGovernmentImage.isUserInteractionEnabled = true
        worldGovernmentImage.addGestureRecognizer(recognizer2)
        
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(showCSU(_:)))
        recognizer3.numberOfTouchesRequired = 1
        recognizer3.numberOfTapsRequired = 1
        csuImage.isUserInteractionEnabled = true
        csuImage.addGestureRecognizer(recognizer3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.grayRavenTextView.textColor = .white
        self.worldGovernmentTextView.textColor = .white
        self.csuTextView.textColor = .white
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func showGrayRaven(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.grayRavenTextView.textColor = .black
        })
    }
    
    @objc func showWorldGovernment(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.worldGovernmentTextView.textColor = .black
        })
    }
    
    @objc func showCSU(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.csuTextView.textColor = .black
        })
    }
}
