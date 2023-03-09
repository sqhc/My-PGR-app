//
//  CharactersViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class CharactersViewController: UIViewController {
    @IBOutlet weak var LuciaImage1: UIImageView!
    @IBOutlet weak var HiddenTextForLucia: UITextView!
    @IBOutlet weak var AlphaImage1: UIImageView!
    @IBOutlet weak var HiddenTextForAlpha: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(showHiddenLucia(_:)))
        recognizer1.numberOfTapsRequired = 1
        recognizer1.numberOfTouchesRequired = 1
        LuciaImage1.isUserInteractionEnabled = true
        LuciaImage1.addGestureRecognizer(recognizer1)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(showHiddenAlpha(_:)))
        recognizer2.numberOfTapsRequired = 1
        recognizer2.numberOfTouchesRequired = 1
        AlphaImage1.isUserInteractionEnabled = true
        AlphaImage1.addGestureRecognizer(recognizer2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        HiddenTextForLucia.alpha = 0.0
        HiddenTextForAlpha.alpha = 0.0
    }
    
    @objc func showHiddenLucia(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 1, animations: {
            self.HiddenTextForLucia.alpha = 1.0
        })
    }
    
    @objc func showHiddenAlpha(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 1, animations: {
            self.HiddenTextForAlpha.alpha = 1.0
        })
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
