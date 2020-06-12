//
//  GameViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 02.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

private let guessedWordsSegue = "presentGuessedWords"
private let explanationScreenSegue = "presentExplanationScreen"
private let gameOverScreenSegue = "showGameOverScreen"

class GameViewController: UIViewController, DismissGuessedVCDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var guessedWordsView: UIView!
    @IBOutlet weak var guessedWordsScrollView: UIScrollView!
    
    @IBOutlet weak var progressCategoryLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var wordTextField: UITextField!
    
    @IBOutlet weak var hexagonsView: UIView!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var centerHexBtn: HexagonButton!
    @IBOutlet weak var upperHexBtn: HexagonButton!
    @IBOutlet weak var lowerHexBtn: HexagonButton!
    @IBOutlet weak var leftUpHexBtn: HexagonButton!
    @IBOutlet weak var leftLowHexBtn: HexagonButton!
    @IBOutlet weak var rightUpHexBtn: HexagonButton!
    @IBOutlet weak var rightLowHexBtn: HexagonButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    
    let diceImages = [UIImage(named: "Dice One"), UIImage(named: "Dice Two"), UIImage(named: "Dice Three"), UIImage(named: "Dice Four"), UIImage(named: "Dice Five"), UIImage(named: "Dice Six")]
    
    // Hexagon-Setup
    
    var width: CGFloat = 0
    var buttonWidth: CGFloat = 100
    
    var buttonHeight: CGFloat = 0
    var centerButtonsXPosition: CGFloat = 0
    var leftButtonsXPosition: CGFloat = 0
    var rightButtonsXPosition: CGFloat = 0
    
    var distanceRightToCenterBtns: CGFloat = 0
    var distanceLeftToCenterBtns: CGFloat = 0
    
    var padding: CGFloat = 10
    
    var hexButtons = [HexagonButton]()
    
    var hexagonsViewWidthPart1: CGFloat = 0
    var hexagonsViewWidthPart2: CGFloat = 0
    
    
    var correctWords = [String]()
    var letters = [String]()
    var foundWords = [String]()
    var maxTime = 0
    var guessedWordsLabels = [UILabel]()
    var dateAdded = Date()
    var isDaily = false
    
    
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    var oldGuessedWords = [String]()
    let emptyWarningLabel = UILabel()
    
    
    // Database
    
    var finalGame: SpellingBeeGame!
    
    var moc: NSManagedObjectContext!
    
    var timer = Timer()
    
    var gameOver = false {
        didSet {
            if gameOver {
                displayGameOverScreen()
            }
        }
    }
    var gameOverScreenPresented = false
    
    var delegate: DismissGameVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        wordTextField.becomeFirstResponder()
        view.endEditing(true)
        wordTextField.inputView = nil
        wordTextField.becomeFirstResponder()
        
        hexButtons.append(contentsOf: [centerHexBtn, upperHexBtn, lowerHexBtn, leftUpHexBtn, leftLowHexBtn, rightUpHexBtn, rightLowHexBtn])
        
        for hexButton in hexButtons {
            hexButton.translatesAutoresizingMaskIntoConstraints = false
            hexButton.setTitle("A", for: .normal)
            hexButton.setTitleColor(.black, for: .normal)
            if hexButton != centerHexBtn {
                hexButton.color = UIColor.init(named: "Gray")
            }
        }
                
        if let gameCorrectWords = finalGame.correctWords, let gameLetters = finalGame.letters, let gameFoundWords = finalGame.guessedWords, let gameDateAdded = finalGame.dateAdded {
            self.correctWords = gameCorrectWords
            self.letters = gameLetters
            self.foundWords = gameFoundWords
            self.dateAdded = gameDateAdded
        } else {
            print("Something's nil")
        }
        
        isDaily = finalGame.isDaily
        
        maxTime = Int(finalGame.maxTime)
        
        buttonsSetup()
        buttonsTitleSetup()
        
        //Scroll View Set Up
        scrollViewSetup()
        scrollViewContentUpdate(setup: true)
        
        progressViewUpdate()
        
        navigationBarSetup()
        
        if finalGame.language == "German" {
            languageLabel.text = NSLocalizedString("DE", comment: "German label in the spelling bee collection view game cell")
        } else if finalGame.language == "English" {
            languageLabel.text = NSLocalizedString("EN", comment: "German label in the spelling bee collection view game cell")
        } else {
            languageLabel.text = "er"
        }
        
        messageLbl.alpha = 0
        
        timerLabel.font = UIFont(name: "Helvetica Bold", size: timerLabel.font.pointSize)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            
            if self.isDaily {
                
                if Calendar.current.isDateInToday(self.dateAdded) == false {
                    self.gameOver = true
                }
                
                self.timerLabel.isHidden = true
                
            } else {
                if self.maxTime != 0 {
                    
                    let textBool = RemainingTime.getRemainingTimeString(dateAdded: self.dateAdded, maxTime: self.maxTime)
                    
                    self.timerLabel.text = textBool.0
                    
                    if textBool.1 && self.gameOver == false {
                        self.gameOver = true
                    }
                } else {
                    
                    self.timerLabel.isHidden = true
                    
                }
            }
        })
        timer.fire()
        
        if finalGame.isNew {
            finalGame.setValue(false, forKey: "isNew")
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
        
        randomShuffleButtonImage()
        
        if Defaults.hasOpenedAGameBefore() == false {
            self.performSegue(withIdentifier: explanationScreenSegue, sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        finalGame.setValue(Date(), forKey: "lastPlayed")
        
        do {
            try moc.save()
            print("changed last Played")
        } catch {
            print(error)
        }
        
        delegate?.fetchGames()
    }
    
    func displayGameOverScreen() {
        
        hexagonsView.alpha = 0.5
        shuffleButton.alpha = 0.5
        
        enterButton.alpha = 0.5
        deleteButton.alpha = 0.5
        
        for button in hexButtons {
            button.isEnabled = false
        }
        shuffleButton.isEnabled = false
        enterButton.isEnabled = false
        deleteButton.isEnabled = false
        
        if gameOverScreenPresented == false {
            gameOverScreenPresented = true
            self.performSegue(withIdentifier: gameOverScreenSegue, sender: self)
        }
    }
    
    func progressViewUpdate() {
        
        // progress View
        self.progressView.setProgress(Ranking.getPercentage(foundWords: foundWords, correctWords: correctWords), animated: true)
        
        // percentage Label
        percentageLabel.text = "\(Int(Ranking.getPercentage(foundWords: foundWords, correctWords: correctWords) * 100)) %"
        
        progressCategoryLabel.text = Ranking.getRanking(percentage: Ranking.getPercentage(foundWords: foundWords, correctWords: correctWords))
        
        amountLabel.text = "\(foundWords.count)"
    }
    
    func scrollViewSetup() {
        
        guessedWordsScrollView.layer.cornerRadius = 5
        guessedWordsScrollView.layer.borderColor = Colors.systemGray3.cgColor
        guessedWordsScrollView.layer.borderWidth = 2
        
        guessedWordsScrollView.isUserInteractionEnabled = true
        guessedWordsScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(guessedWordsScrollViewTapped)))
        
        gradientView.frame = guessedWordsScrollView.frameLayoutGuide.layoutFrame
        
        var leftColor: CGColor!
        var rightColor: CGColor!
        
        if self.traitCollection.userInterfaceStyle == .dark {
            leftColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            rightColor = UIColor.black.cgColor
        } else {
            leftColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
            rightColor = UIColor.white.cgColor
        }
        
        gradientLayer.frame = gradientView.frame
        gradientLayer.colors = [leftColor!, rightColor!]
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.75, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.95, y: 0.5)
        }
        
        
        gradientView.layer.addSublayer(gradientLayer)
        guessedWordsScrollView.addSubview(gradientView)
        
        
        if foundWords.isEmpty {
            
            emptyWarningLabel.text = NSLocalizedString("No words found yet", comment: "empty warning label in the game view controller")
            emptyWarningLabel.textColor = Colors.systemGray3
            emptyWarningLabel.sizeToFit()
            emptyWarningLabel.translatesAutoresizingMaskIntoConstraints = false
            guessedWordsScrollView.addSubview(emptyWarningLabel)
            
            NSLayoutConstraint.activate([
                
                emptyWarningLabel.centerXAnchor.constraint(equalTo: guessedWordsView.centerXAnchor),
                emptyWarningLabel.centerYAnchor.constraint(equalTo: guessedWordsView.centerYAnchor)
                
            ])
        }
    }
    
    func scrollViewContentUpdate(setup: Bool = false) {
        
        if foundWords.isEmpty == false {
            emptyWarningLabel.isHidden = true
        }
        
        var foundWordsSwitch = [String]()
        
        if setup == true {
            foundWordsSwitch = foundWords.reversed()
        } else {
            foundWordsSwitch = oldGuessedWords.difference(from: foundWords)
        }
        
        let padding: CGFloat = 8
        var offSetCounter: CGFloat = 0
        
        for word in foundWordsSwitch {
                        
            let label = UILabel()
            label.text = word
            
            guessedWordsScrollView.addSubview(label)
            guessedWordsScrollView.bringSubviewToFront(gradientView)
            
            if setup == true {
                
                label.sizeToFit()
                label.frame.origin = CGPoint(x: offSetCounter + padding, y: (guessedWordsScrollView.frame.height - label.frame.height) / 2)
                    
            } else {
                
                label.sizeToFit()
                label.alpha = 0
                label.frame.origin = CGPoint(x: offSetCounter + padding, y: (guessedWordsScrollView.frame.height - label.frame.height) / 2)
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    for guessedLabel in self.guessedWordsLabels {
                        guessedLabel.frame.origin.x += label.frame.width + padding
                    }
                    
                }) { (true) in
                    UIView.animate(withDuration: 0.5) {
                        label.alpha = 1
                    }
                }
            }
            
            guessedWordsLabels.append(label)
            
            offSetCounter += padding + label.frame.width
        }
        
        oldGuessedWords = foundWords
    }
    
    func navigationBarSetup() {
        
        if isDaily {
            print("That's a daily")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let dateString = dateFormatter.string(from: self.dateAdded)
            navigationItem.title = dateString
            
        }
        
        //hides the navigationbar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "Black")!]
//        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "Yellow")
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "Yellow")
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Black")

        
        //creates question mark Button on the upper right corner
        let customButton = UIButton()
        customButton.setImage(UIImage(named: "Questionmark Button"), for: .normal)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = Colors.navigationBarButtonColor
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.addTarget(self, action: #selector(questionMarkButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            customButton.heightAnchor.constraint(equalToConstant: 35),
            customButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        let rightBarbutton = UIBarButtonItem(customView: customButton)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    func buttonsTitleSetup() {
        
        var titleLetters = letters

        centerHexBtn.setTitle(titleLetters[0], for: .normal)
        titleLetters.remove(at: 0)

        titleLetters.shuffle()

        for i in 1...hexButtons.count - 1 {
            hexButtons[i].setTitle(titleLetters[i - 1], for: .normal)
        }
        
        
    }
    
    
    // MARK: - Dark Mode
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientView.removeFromSuperview()
        gradientLayer.removeFromSuperlayer()
        scrollViewSetup()
    }
    
    
    // MARK: - Buttons
    
    @IBAction func hexBtnPressed(_ sender: Any) {
        
        if let hexBtn = sender as? HexagonButton {
            
            wordTextField.text! += hexBtn.titleLabel!.text!
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        
        if let typedWord = wordTextField.text {
            if typedWord.count > 0 {
                wordTextField.text!.removeLast(1)
            }
        }
    }
    
    
    @IBAction func enterBtnPressed(_ sender: Any) {
        
        if let enteredWord = wordTextField.text {
            
            if enteredWord.count < 4 {
                animateMsgLbl(text: NSLocalizedString("You need at least 4 letters", comment: "Less than 4 letters message in the GameViewController"))
                
                wordTextField.text = ""
                return
            }
            
            if enteredWord.contains(centerHexBtn.titleLabel!.text!) { // Does it contain center letter?
                if correctWords.contains(enteredWord) { // Is the word correct?
                    if foundWords.contains(enteredWord) { // Has the word already been found?
                        animateMsgLbl(text: NSLocalizedString("Already found", comment: "Already found message in the GameViewController"))
                    } else { // CORRECT!
                        
                        if BeeHive.checkForPangram(word: enteredWord) { // Pangram
                             animateMsgLbl(text: NSLocalizedString("PANGRAM", comment: "Pangram message in the GameViewController"), pangram: true)
                        } else {
                            
                            // Different Text depending on amount of letters
                            
                            animateMsgLbl(text: NSLocalizedString("Correct", comment: "Correct message in the GameViewController"))
                        }
                        
                        foundWords.append(enteredWord)
                        
                        finalGame.setValue(foundWords, forKey: "guessedWords")
                        
//                        scrollViewContentUpdate()
//                        progressViewUpdate()
                        
                        do {
                            try moc.save()
                            scrollViewContentUpdate()
                            progressViewUpdate()
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    animateMsgLbl(text: NSLocalizedString("Wrong", comment: "Wrong message in the GameViewController"))
                }
            } else {
                animateMsgLbl(text: NSLocalizedString("Doesn't contain center letter", comment: "Doesn't contain center letter message in the GameViewController"))
            }
            
            
            wordTextField.text = ""
            
        } else {
            print("enteredWord is nil")
        }
    }
    
    @IBAction func shuffleBtnPressed(_ sender: Any) {
        
        let animationDuration = 0.3
        
        UIView.animate(withDuration: animationDuration, animations: {
            for hexBtn in self.hexButtons {
                hexBtn.titleLabel!.alpha = 0
            }
            self.shuffleButton.alpha = 0
        }) { (true) in
            self.buttonsTitleSetup()
            
            self.randomShuffleButtonImage()
            
            UIView.animate(withDuration: animationDuration) {
                for hexBtn in self.hexButtons {
                    hexBtn.titleLabel!.alpha = 1
                }
                self.shuffleButton.alpha = 1
            }
        }
    }
    
    func randomShuffleButtonImage() {
        let currentButtonImage = self.shuffleButton.imageView!.image!
        var foundNewImage = false
        var newImage: UIImage!
        
        while foundNewImage == false {
            
            newImage = self.diceImages.shuffled()[0]
            if newImage != currentButtonImage {
                foundNewImage = true
            } else {
                foundNewImage = false
            }
        }
        
        self.shuffleButton.setImage(newImage, for: .normal)
    }
    
    func animateMsgLbl(text: String, pangram: Bool = false) {
        
        messageLbl.text = text
        
        if pangram {
            messageLbl.textColor = UIColor(named: "Yellow")
            messageLbl.font = UIFont(name: "Helvetica Bold", size: messageLbl.font.pointSize)
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.messageLbl.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
                self.messageLbl.alpha = 0
            }) { (true) in
                // make label normal again
                let randomLabel = UILabel()
                
                self.messageLbl.textColor = randomLabel.textColor
                self.messageLbl.font = UIFont(name: "Helvetica", size: self.messageLbl.font.pointSize)
            }
        }
    }
    
    func shakeTextView() {
        
        wordTextField.transform = CGAffineTransform(translationX: 7, y: 0)
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: CGFloat(wordTextField.text!.count) * 0.02, initialSpringVelocity: 1, options: [], animations: {
            self.wordTextField.transform = CGAffineTransform.identity
        }) { (true) in
            
        }
    }
    
    @objc func questionMarkButtonPressed() {
        // performs segue to the explanation view controller
        vibration.lightVibration()
        self.performSegue(withIdentifier: explanationScreenSegue, sender: self)
    }
    
    @objc func guessedWordsScrollViewTapped() {
        // only performs segue when there are any found words
        vibration.lightVibration()
        self.performSegue(withIdentifier: guessedWordsSegue, sender: self)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == guessedWordsSegue {
            if let destinationVC = segue.destination as? GuessedWordsViewController {
                
                destinationVC.delegate = self
                destinationVC.presentationController?.delegate = destinationVC
                
                destinationVC.game = finalGame
                destinationVC.gameOver = gameOver
            }
        } else if segue.identifier == explanationScreenSegue {
            
            if let destinationVC = segue.destination as? ExplanationViewController {
                
                destinationVC.game = self.finalGame
            }
        } else if segue.identifier == gameOverScreenSegue {
            
            if let destinationVC = segue.destination as? GameOverViewController {
                
                destinationVC.ranking = Ranking.getRanking(percentage: Ranking.getPercentage(foundWords: foundWords, correctWords: correctWords))
                destinationVC.foundWordsAmount = foundWords.count
                destinationVC.totalWordsAmount = correctWords.count
            }
        }
    }
    
    
    // MARK: - DismissGuessedVCDelegate
    
    func dismissGuessedVC(gameOver: Bool) {
        print(gameOver)
        if gameOver {
            self.gameOver = true
            self.maxTime = 1
        }
    }
    
}

protocol DismissGameVCDelegate {
    
    func fetchGames()
}
