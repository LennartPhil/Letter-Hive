//
//  ViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 30.03.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

private let segueIdentifier = "showGameVC"

class LoadingGameViewController: UIViewController {
    
    @IBOutlet weak var loadingBgView: UIVisualEffectView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var hexagonsBgView: UIView!
    
    var allLetters = [String]()
    var otherLetters = [String]()
    var centerLetter = ""
    var language: Language!
    var maxTime = 0
    var isDaily = false
    var version = 0
    
    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    private var words = [String]()
    private var pangram = ""
    
    private var percentageText = 0
    
    private var percentage: Double = 0 {
        didSet {
            animateHexagons(percentage: percentage)
        }
    }
    
    private var oldPercentage: Double = 0
    
    private var hexagonViews = [HexagonView]()
    
    private var correctWords: [String] = [] {
        didSet {
            print(correctWords)
        }
    }
    
//    var game: SpellingBeeGame!
    private var moc: NSManagedObjectContext!
    
    var isPerformingSegue = false
    var didSave = false
    
    var delegate: ReloadCollectionViewContentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if isDaily { // Look I really don't know why I have to do it like this but that's the way it is
            pangram = BeeHive.getPangrams(language: language).shuffled()[0]
            
            var letters = BeeHive.getDifferentLetters(string: pangram)
            print(letters)
            
            centerLetter = letters[0]
            letters.removeFirst()
            otherLetters = letters
            
            //Prevent user from exiting vc when it's a daiyl
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = true
            }
        }
        
        allLetters = [centerLetter] + otherLetters
        
        setupLoadingView()
                
        createBackground(width: 50)
        prepareBgAnimation()
        
        
        
        loadingBgView.isHidden = false
        
        loadWords(language: language)
        
//        createBackground(width: 50)
    }
    
    func setupLoadingView() {
        
        loadingBgView.layer.cornerRadius = loadingBgView.frame.size.height / 6
        loadingBgView.isHidden = true
        loadingBgView.layer.masksToBounds = true
    }
    
    func createBackground(width: Int) {
        
        hexagonsBgView.layer.masksToBounds = true
        
//        let verticalHeight = self.view.frame.height - self.view.safeAreaInsets.top
        let verticalHeight = self.view.frame.height

        
        let verticalAmountDivider = width + (width / 5)
        let verticalAmount = Int(verticalHeight) / verticalAmountDivider
        
        let horizontalWidth = self.view.frame.width
        
        let horizontalAmountDivider = verticalAmountDivider
        let horizontalAmount = Int(horizontalWidth) / horizontalAmountDivider
        
//        let gap = (width / 2) * 3
        let gap = width / 2
        
        for xPos in 0...horizontalAmount {
            
            
            
            for yPos in 0...verticalAmount {
                
                var yPosition1 = 0
                var yPosition2 = 0
                var yPosition3 = 0
                var yPosition = 0
                
                if xPos % 2 == 0 {
//                    yPosition1 = Int(self.view.safeAreaInsets.top) + (yPos * gap)
                    yPosition1 = yPos * (width + gap)

                    yPosition2 = (2 * width + gap) / 2
                    yPosition3 = width / 2
                    yPosition = yPosition1 - (yPosition2 - yPosition3)
                } else {
//                    yPosition = Int(self.view.safeAreaInsets.top) + (yPos * gap)
                    yPosition = yPos * (width + gap)
                }
                
                let hexagonView = HexagonView()
                hexagonView.frame = CGRect(x: -(width / 2) + (xPos * (width + gap)), y: yPosition, width: width, height: width)
                hexagonView.transform = CGAffineTransform(rotationAngle: .pi / 2)
                
                self.hexagonsBgView.addSubview(hexagonView)
                self.hexagonsBgView.sendSubviewToBack(hexagonView)
                hexagonViews.append(hexagonView)
            }
        }
    }
    
    func prepareBgAnimation() {
        
        for hexagonView in hexagonViews {
            hexagonView.alpha = 0
        }
        
    }
    
    func animateHexagons(percentage: Double) {
        
//        let hexagonPercentage: Double = Double(hexagonViews.count) / 100.0
        let hexagonPercentage: Double = 100.0 / Double(hexagonViews.count)
        
        print(hexagonPercentage)
        print("Max. Hexagon: \(hexagonViews.count)")
        
        if percentage == 100 {
            
            var delayCounter: Double = 0
            
            for view in hexagonViews {
                if view.alpha == 0 {
                    animateHexagonView(view: view, delay: delayCounter)
                    delayCounter += 1
                }
            }
            
            showGameVC()
            
            return
        }
        
        if percentage > oldPercentage {
            
            print("Hello")
            
            let difference = percentage - oldPercentage
            
            if difference >= hexagonPercentage {
                
                let hexagonAmount = Int(difference / hexagonPercentage)
                print(hexagonAmount)
                
                oldPercentage = percentage
                
                for _ in 1...hexagonAmount {
                    var isVisible = true
                    
                    var randomHexagon = HexagonView()
                    
                    while isVisible {
                        
                        randomHexagon = hexagonViews.randomElement()!
                        
                        if randomHexagon.alpha == 0 {
                            isVisible = false
                        }
                        
                    }
                    
                    animateHexagonView(view: randomHexagon)
                }
                
            }
        }
    }
    
    func animateHexagonView(view: HexagonView, delay: Double = 0) {
        UIView.animate(withDuration: 0.3, delay: delay * 0.1, options: [], animations: {
            view.alpha = 1
        }, completion: nil)
    }
    
    func loadWords(language: Language) {
        
        if language == .german {
            if let textPath = Bundle.main.path(forResource: "filtered german words", ofType: "txt") {
                print("file found")
                if let allString = try? String(contentsOfFile: textPath) {
                    let words = allString.components(separatedBy: "\n")
                    self.words = words
                    self.version = Int(words[0])!
                    self.words.remove(at: 0)
                }
            }
        } else if language == .english {
            if let textPath = Bundle.main.path(forResource: "english words", ofType: "txt") {
                print("file found")
                if let allString = try? String(contentsOfFile: textPath) {
                    let words = allString.components(separatedBy: "\n")
                    self.words = words
                    self.version = Int(words[0])!
                    self.words.remove(at: 0)
                }
            }
        }
        
        
        print(words.count)
        
        //Makes all the words uppercased and removes all the words that have 3 or less characters
        words = words.map { $0.uppercased() }
        words = words.filter { $0.count > 3 }
        
        var newAlphabet = alphabet
        
        for letter in allLetters {
            newAlphabet = newAlphabet.filter { $0 != letter }
        }
        
        print(newAlphabet)
        
        print(words.count)
        
        let maxCount = words.count
        
        var result = words
        
        print(result.count)
        
        var counter = 0
        var wordCounter = 0
        
        var hasFinishedWord = false
        
        DispatchQueue.global(qos: .background).async {
            for word in self.words {
                
                wordCounter += 1
                
                var otherCounter = 0
                
                hasFinishedWord = false
                
                for letter in newAlphabet {
                    
                    if hasFinishedWord == false {
                        otherCounter += 1
                        
                        if word.contains(letter) {
                            result.remove(at: counter)
                            hasFinishedWord = true
                            counter -= 1
                        } else if word.contains(letter) == false {
                            continue
                        }
                        
                    } else {
                        continue
                    }
                }
                
                
//                print(Int(round(Double(wordCounter) / Double(maxCount) * 100)))
                
                counter += 1
                
                DispatchQueue.main.async {
                    print(Double(wordCounter) / Double(maxCount) * 100.0)
                    self.percentageLabel.text = "\(Int(round(Double(wordCounter) / Double(maxCount) * 100))) %"
                    self.progressView.progress = Float(Double(wordCounter) / Double(maxCount))
                    self.percentage = Double(wordCounter) / Double(maxCount) * 100.0
                }
                
            }
            
            // removes words that don't contains the center letter
            self.correctWords = result.filter {
                $0.contains(self.centerLetter)
            }
            
            // removes duplicates from the array
            self.correctWords = self.correctWords.removingDuplicates()
        }
    }
    
    func showGameVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isPerformingSegue == false {
                self.isPerformingSegue = true
                                
                self.saveGame()
                
                self.performSegue(withIdentifier: "backToCollectionViewFromLoadingGameVCSegue", sender: self)
                self.delegate?.reloadCollectionViewContent()
            }
        }
    }
    
    func saveGame() {
        
        if didSave == false {
            
            let game = SpellingBeeGame(context: moc)
            game.correctWords = self.correctWords
            game.guessedWords = []
            game.dateAdded = Date()
            game.lastPlayed = Date()
            game.isDaily = isDaily
            game.language = self.language.rawValue
            game.maxTime = Int64(self.maxTime)
            game.letters = self.allLetters
            game.isNew = true
            game.wordsVersion = Int64(self.version)
            
            do {
                try moc.save()
                didSave = true
                print("successfully saved game")
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier {
            if let destinationVC = segue.destination as? GameViewController {
                                
                let game = SpellingBeeGame()
                game.correctWords = self.correctWords
                game.guessedWords = []
                game.dateAdded = Date()
                game.lastPlayed = Date()
                game.isDaily = isDaily
                game.language = self.language.rawValue
                game.maxTime = Int64(self.maxTime)
                game.letters = self.allLetters
                game.wordsVersion = Int64(self.version)
                
                destinationVC.finalGame = game
            }
        }
    }
}


protocol ReloadCollectionViewContentDelegate {
    
    func reloadCollectionViewContent()
}

