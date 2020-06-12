//
//  GameOverViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 20.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var foundWordsLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    var ranking: String!
    var foundWordsAmount: Int!
    var totalWordsAmount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        gameOverLabel.text = NSLocalizedString("Game Over", comment: "Gamer Over label in the GameOverVC")
        rankingLabel.text = "\(ranking ?? NSLocalizedString("Good job", comment: "Default Ranking text in the GameOverVC"))!"
        foundWordsLabel.text = String(format: NSLocalizedString("You've found %@ of %@ words", comment: "Found words label in the GameOverVC"), "\(foundWordsAmount!)", "\(totalWordsAmount!)")
        
        okayButton.setTitle(NSLocalizedString("Got it", comment: "Okay Button title in the GameOverVC"), for: .normal)
        okayButton.setTitleColor(.white, for: .normal)
        okayButton.backgroundColor = Colors.yellow
        okayButton.titleLabel!.font = UIFont.systemFont(ofSize: okayButton.titleLabel!.font.pointSize, weight: .bold)
        okayButton.layer.cornerRadius = okayButton.frame.height / 2
        
        containerView.isUserInteractionEnabled = false
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.3
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        
//        startAnimation()
        startAnimation()
    }
    
    func startAnimation() {
        
        containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        containerView.transform = CGAffineTransform(translationX: 100, y: 100)
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
            self.containerView.transform = .identity
        }) { (true) in
            //
        }
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okayButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
