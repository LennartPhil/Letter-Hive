//
//  Structs.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 24.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Vibration

public struct vibration {
    
    static func lightVibration() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Ranking

public struct Ranking {
    
    static let ranking = [
        0:NSLocalizedString("Beginner", comment: "Beginner Ranking"),
        1:NSLocalizedString("Good Start", comment: "Good Start Ranking"),
        2:NSLocalizedString("Moving Up", comment: "Moving Up Ranking"),
        3:NSLocalizedString("Good", comment: "Good Ranking"),
        4:NSLocalizedString("Solid", comment: "Solid Ranking"),
        5:NSLocalizedString("Nice", comment: "Nice Ranking"),
        6:NSLocalizedString("Great", comment: "Great Ranking"),
        7:NSLocalizedString("Amazing", comment: "Amazing Ranking"),
        8:NSLocalizedString("Genius", comment: "Genius Ranking")
    ]
    
    static func getRanking(percentage: Float) -> String {
        
        if percentage < 0.1 {
            return ranking[0]!
        } else if percentage < 0.2 {
            return ranking[1]!
        } else if percentage < 0.3 {
            return ranking[2]!
        } else if percentage < 0.4 {
            return ranking[3]!
        } else if percentage < 0.5 {
            return ranking[4]!
        } else if percentage < 0.6 {
            return ranking[5]!
        } else if percentage < 0.7 {
            return ranking[6]!
        } else if percentage < 0.8 {
            return ranking[7]!
        } else if percentage < 0.9 {
            return ranking[8]!
        }
        
        return ranking[0]!
    }
    
    static func getPercentage(foundWords: [String]?, correctWords: [String]?) -> Float {
        
        if foundWords != nil && correctWords != nil {
            
            var maxWordLength: Float = 0
            var currentWordLength: Float = 0
            
            
            for word in correctWords! {
                maxWordLength += Float(word.count)
            }
            
            for word in foundWords! {
                currentWordLength += Float(word.count)
            }
            
            let currentProgress = currentWordLength / maxWordLength
            
            return currentProgress
            
        } else {
            return 0
        }
        
        
    }
}

// MARK: - Remaining Time

public struct RemainingTime {
    
    static func getRemainingTimeString(dateAdded: Date, maxTime: Int) -> (String, Bool) {
        
        let componentsFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            return formatter
        }()
        
        let expirationDate = dateAdded.addingTimeInterval(TimeInterval(maxTime))
        let now = Date()
        
        if expirationDate < now {
            return (NSLocalizedString("Game over", comment: "Game over"), true)
        } else {
            let desiredComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let components = Calendar.current.dateComponents(desiredComponents, from: now, to: expirationDate)
            return (componentsFormatter.string(from: components)!, false)
        }
    }
}

// MARK: - Bee Hive

public struct BeeHive {
    
    // Checks if a word is a pangram
    static func checkForPangram(word: String) -> Bool {
        
        var differentLetters = [Character]()
        
        for letter in word {
            if differentLetters.contains(letter) == false {
                differentLetters.append(letter)
            }
        }
        
        if differentLetters.count == 7 {
            return true
        } else {
            return false
        }
    }
    
    
    // Returns all the pangrams
    static func getPangrams(language: Language) -> [String] {
        
        if language == .german {
            if let textPath = Bundle.main.path(forResource: "german pangrams", ofType: "txt") {
                print("file found")
                if let allString = try? String(contentsOfFile: textPath) {
                    let pangrams = allString.components(separatedBy: "\n")
                    return pangrams
                } else {
                    print("couldn't get the content of the german pangram text file")
                    return []
                }
            } else {
                print("couldn't get the german pangram text file")
                return []
            }
        } else if language == .english {
            if let textPath = Bundle.main.path(forResource: "english pangrams", ofType: "txt") {
                print("file found")
                if let allString = try? String(contentsOfFile: textPath) {
                    let pangrams = allString.components(separatedBy: "\n")
                    return pangrams
                } else {
                    print("couldn't get content of english pangram text file")
                    return []
                }
            } else {
                print("couldn't get the english pangram text file")
                return []
            }
        }
        
        print("other language than english or german")
        return []
    }
    
    static func getDifferentLetters(string: String) -> [String] {
        
        var letters = [String]()
        for letter in string {
            if letters.contains(String(letter)) == false {
                letters.append(String(letter))
            }
        }
        
        return letters.shuffled()
    }
}

// MARK: - Core Data

public struct CoreData {
    
    static let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveNewGame(isDaily: Bool, maxTime: Int64, correctWords: [String], letters: [String], language: Language) {
        
        let game = SpellingBeeGame(context: moc)
        game.isDaily = isDaily
        game.maxTime = maxTime
        game.letters = letters
        game.correctWords = correctWords
        game.guessedWords = []
        game.dateAdded = Date()
        game.lastPlayed = Date()
        game.language = language.rawValue
        game.wordsVersion = Int64(1)
        game.isNew = true
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - Warnings

public struct Warnings {
    
    static func presentAlert(with title: String, and message: String, in currentViewController: UIViewController) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action the alter controller"), style: .cancel, handler: nil))
        
        currentViewController.present(ac, animated: true, completion: nil)
    }
}

// MARK: - Defaults

public struct Defaults {
    
    static let standardLanguageString = "customStandardLanguage"
    
    static func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    static func hasOpenedAGameBefore() -> Bool {
        let defautls = UserDefaults.standard
        if let _ = defautls.string(forKey: "hasOpenedAGameBefore") {
            return true
        } else {
            defautls.set(true, forKey: "hasOpenedAGameBefore")
            return false
        }
    }
    
    static func currentStandardLanguage() -> Language {
        let defaults = UserDefaults.standard
        if let standardLanguage = defaults.string(forKey: standardLanguageString) {
            return Language(rawValue: standardLanguage)!
        } else {
            defaults.set(DeviceLanguage.deviceLanguage().rawValue, forKey: standardLanguageString)
            return DeviceLanguage.deviceLanguage()
        }
    }
    
    static func setStandardLanguage(language: Language) {
        let defaults = UserDefaults.standard
        defaults.set(language.rawValue, forKey: standardLanguageString)
    }
}

// MARK: - Device Language

public struct DeviceLanguage {
    
    static func deviceLanguage() -> Language {
        if Locale.current.description.hasPrefix("de") {
            return .german
        } else if Locale.current.description.hasPrefix("en") {
            return .english
        } else {
            return .english
        }
    }
    
    static func translatedLanguage(language: Language) -> String {
        
        let germanString = NSLocalizedString(language.rawValue, comment: "German Device Language")
        let englishString = NSLocalizedString(language.rawValue, comment: "English Device Lanugage")
        
        if language == .german {
            return germanString
        } else if language == .english {
            return englishString
        } else {
            return englishString
        }
    }
    
}

// MARK: - Colors

public struct Colors {
    
    static let systemGray3: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemGray3
        } else {
            return UIColor(red: 0.7803921568627451, green: 0.7803921568627451, blue: 0.8, alpha: 1.0)
        }
    }()
    
    static let navigationBarButtonColor: UIColor = {
        return UIColor(named: "Navigation Bar Button")!
//        return UIColor(named: "Gray")!
    }()
    
    static let yellow: UIColor = {
        return UIColor(named: "Yellow")!
    }()
}


