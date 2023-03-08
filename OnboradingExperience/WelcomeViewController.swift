//
//  WelcomeViewController.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/5/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var holderView: UIView!
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    private func configure(){
        // Set up scrollView
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        let titles = ["Dark", "Physics", "Thunder", "Ice", "Fire"]
        
        for i in 0..<5{
            let pageView = UIView(frame: CGRect(x: CGFloat(i) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // Title, image, button
            let label = UILabel(frame: CGRect(x:10, y: 10, width: pageView.frame.size.width-20, height: 120))
            let image = UIImageView(frame: CGRect(x:10, y: 10+120+10, width: pageView.frame.size.width-20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x:10, y: pageView.frame.size.height-60, width: pageView.frame.size.width-20, height: 50))
            
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            label.text = titles[i]
            pageView.addSubview(label)
            
            image.contentMode = .scaleAspectFit
            image.image = UIImage(named: "welcome_\(i + 1)")
            pageView.addSubview(image)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            if i != 4{
                button.setTitle("Continue", for: .normal)
            }
            else{
                button.setTitle("Start", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = i + 1
            pageView.addSubview(button)
        }
        scrollView.contentSize = CGSize(width: holderView.frame.size.width*5, height: 0)
        scrollView.isPagingEnabled = true
        
    }
    
    @objc func didTapButton(_ button: UIButton){
        guard button.tag < 5 else {
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }//dismiss
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
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
