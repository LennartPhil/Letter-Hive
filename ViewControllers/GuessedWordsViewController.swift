//
//  GuessedWordsViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 06.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

private let textImageReuseIdentifier = "textImageCell"
private let titleCellReuseIdentifier = "titleCell"

class GuessedWordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DismissViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
    
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonRoundedCornersView: UIView!
    @IBOutlet weak var solveButton: UIButton!
    
    var game: SpellingBeeGame!
    var correctWords = [String]()
    var guessedWords = [String]()
    var gameOver = false
    
    let buttonViewCornerRadius: CGFloat = 15
    
    let label = UILabel()
    let finalSolveButton = CustomButton()
    let cancelButton = CustomButton()
    let stackView = UIStackView()
    
    var moc: NSManagedObjectContext!
    
    var delegate: DismissGuessedVCDelegate?
    
    var pangrams = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.tableView.tableFooterView = UIView()
        
//        buttonRoundedCornersView.roundCorners(corners: [.topLeft, .topRight], radius: buttonViewCornerRadius)
        buttonRoundedCornersView.layer.cornerRadius = buttonViewCornerRadius
        buttonRoundedCornersView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        buttonRoundedCornersView.backgroundColor = UIColor(named: "Light White")
        
        setupButtonView()
        
        solveButton.backgroundColor = UIColor(named: "Yellow")
        solveButton.setTitle("Solve Game", for: .normal)
        solveButton.setTitleColor(.white, for: .normal)
        solveButton.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 20)
        
        solveButton.layer.cornerRadius = buttonViewCornerRadius
        solveButton.clipsToBounds = true
        
        tableView.separatorStyle = .none
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 2)
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = false
        
        if let correctWords = game.correctWords, let guessedWords = game.guessedWords {
            
            self.correctWords = correctWords.sorted(by: { $0 < $1 })
            self.guessedWords = guessedWords.sorted(by: { $0 < $1 })
        }
        
        if gameOver || game.isDaily {
            
            buttonView.isHidden = true
            
            //change table view content and reload table view
        }
        
        pangrams = BeeHive.getPangrams(language: Language(rawValue: game.language!)!)
    }
    
    func setupButtonView() {
        
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttonView.layer.backgroundColor = UIColor.clear.cgColor
//        buttonView.layer.shadowColor = UIColor.darkGray.cgColor
        buttonView.layer.shadowRadius = 5
        buttonView.layer.shadowOpacity = 1
        
        if self.traitCollection.userInterfaceStyle == .dark {
            buttonView.layer.shadowColor = UIColor.black.cgColor
        } else {
            buttonView.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
    
    // MARK: - Table view data sorce
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gameOver {
            return correctWords.count + 2
        } else {
            return guessedWords.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCellReuseIdentifier, for: indexPath) as! TitleTableViewCell
            cell.titleLabel.text = NSLocalizedString("Guessed Words", comment: "Guessed words title in the guessed words table view controller")
            cell.delegate = self
            
            return cell
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "amountCell", for: indexPath)
            
            if gameOver {
                cell.textLabel!.text = String(format: NSLocalizedString("%@ of %@ words found", comment: "Word Amount Text if GameOver"), "\(guessedWords.count)", "\(correctWords.count)")
            } else {
                cell.textLabel!.text = String(format: NSLocalizedString("%@ of ? words found", comment: "Word Amount Text"), "\(guessedWords.count)")
            }
            
            cell.textLabel!.font = UIFont.systemFont(ofSize: cell.textLabel!.font.pointSize, weight: .bold)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: textImageReuseIdentifier, for: indexPath) as! TextImageTableViewCell
            
            if gameOver {
                
                let word = correctWords[indexPath.row - 2]
                
                cell.wordLabel.text = word
                
                if guessedWords.contains(word) {
                    cell.tickImageView.isHidden = false
                } else {
                    cell.tickImageView.isHidden = true
                }
                
                changeLabelColor(label: cell.wordLabel, word: word)
                
            } else {
                let word = guessedWords[indexPath.row - 2]
                
                cell.wordLabel.text = word
                
                changeLabelColor(label: cell.wordLabel, word: word)
                
                cell.tickImageView.isHidden = true
            }
            
            return cell
        }
    }
    
    func changeLabelColor(label: UILabel, word: String) {
        
        if pangrams.contains(word) {
            label.textColor = UIColor(named: "Yellow")
            label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .bold)
        } else {
            label.textColor = UIColor(named: "Black")
            label.font = UIFont.systemFont(ofSize: label.font.pointSize, weight: .regular)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 30
        } else {
            return 44
        }
    }
    
    // MARK: - Dismiss View Controller Delegate
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
        delegate?.dismissGuessedVC(gameOver: gameOver)
    }
    
    
    @IBAction func solveGameButtonPressed(_ sender: Any) {
        
        label.text = NSLocalizedString("Are you sure?", comment: "Are you sure question when game is solved in Guessed Words VC")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Bold", size: 20)
        label.textAlignment = .center
        label.alpha = 0
        
        finalSolveButton.setTitle(NSLocalizedString("Solve", comment: "Solve game in Guessed Words VC"), for: .normal)
        finalSolveButton.setTitleColor(.white, for: .normal)
        finalSolveButton.backgroundColor = UIColor(named: "Yellow")
        finalSolveButton.translatesAutoresizingMaskIntoConstraints = false
        finalSolveButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 20)
        finalSolveButton.addTarget(self, action: #selector(solveGame), for: .touchUpInside)
        finalSolveButton.layer.cornerRadius = buttonViewCornerRadius
        finalSolveButton.clipsToBounds = true
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel Solving in Guessed Words VC"), for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = Colors.systemGray3
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 20)
        cancelButton.addTarget(self, action: #selector(cancelSolving), for: .touchUpInside)
        cancelButton.layer.cornerRadius = buttonViewCornerRadius
        cancelButton.clipsToBounds = true
        
        stackView.addArrangedSubview(finalSolveButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.contentMode = .center
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alpha = 0
        
        buttonRoundedCornersView.addSubview(label)
        buttonRoundedCornersView.addSubview(stackView)
        
        NSLayoutConstraint.activate([

            label.leadingAnchor.constraint(equalTo: buttonRoundedCornersView.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: buttonRoundedCornersView.trailingAnchor, constant: -30),
            label.topAnchor.constraint(equalTo: buttonRoundedCornersView.topAnchor, constant: 30),
            
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: buttonRoundedCornersView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: buttonRoundedCornersView.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: buttonRoundedCornersView.bottomAnchor, constant: -30),

            finalSolveButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.solveButton.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                self.buttonViewHeight.constant = 160
                self.view.layoutIfNeeded()
            }) { (true) in
                UIView.animate(withDuration: 0.3) {
                    self.label.alpha = 1
                    self.stackView.alpha = 1
                }
            }
        }
    }
    
    @objc func solveGame() {
        
        game.setValue(1, forKey: "maxTime")
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
        delegate?.dismissGuessedVC(gameOver: gameOver)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 1) {
                self.buttonViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        gameOver = true
//        self.tableView.reloadData()
//
//        UIView.transition(with: tableView, duration: 1, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        
    }
    
    @objc func cancelSolving() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.label.alpha = 0
            self.stackView.alpha = 0
        }) { (true) in
            self.label.removeFromSuperview()
            self.stackView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                self.buttonViewHeight.constant = 130
                self.view.layoutIfNeeded()
                vibration.lightVibration()
            }) { (true) in
                
                UIView.animate(withDuration: 0.3) {
                    self.solveButton.alpha = 1
                }
            }
        }
    }
    
    // MARK: - Darkmode
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupButtonView()
    }
    
    // MARK: - Presentation Controller Delegate
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        delegate?.dismissGuessedVC(gameOver: gameOver)
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

protocol DismissGuessedVCDelegate {
    
    func dismissGuessedVC(gameOver: Bool)
    
}
