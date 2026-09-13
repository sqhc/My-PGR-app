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

    /// Pages already built, used to make `configure()` idempotent.
    private var pages: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    private func configure(){
        // This runs on every layout pass; without the guard each pass would
        // append another set of pages to the same scroll view.
        guard pages.isEmpty else { return }

        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        let titles = ["Dark", "Physics", "Thunder", "Ice", "Fire"]

        for i in 0..<titles.count {
            let pageView = UIView(frame: CGRect(x: CGFloat(i) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            pages.append(pageView)

            // Title, image, button
            let label = UILabel(frame: CGRect(x:10, y: 10, width: pageView.frame.size.width-20, height: 120))
            let image = UIImageView(frame: CGRect(x:10, y: 10+120+10, width: pageView.frame.size.width-20, height: pageView.frame.size.height - 60 - 130 - 15))
            let button = UIButton(frame: CGRect(x:10, y: pageView.frame.size.height-60, width: pageView.frame.size.width-20, height: 50))

            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            label.text = titles[i]
            pageView.addSubview(label)

            image.contentMode = .scaleAspectFit
            // These five images ship with the app; a missing one is a build
            // problem, so surface it rather than showing an empty frame.
            image.image = UIImage(named: "welcome_\(i + 1)") ?? UIImage.placeholder
            pageView.addSubview(image)

            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            if i != titles.count - 1 {
                button.setTitle("Continue", for: .normal)
            }
            else{
                button.setTitle("Start", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = i + 1
            pageView.addSubview(button)
        }
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * CGFloat(titles.count), height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton){
        guard button.tag < 5 else {
            Core.setIsNotNewUser()
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
