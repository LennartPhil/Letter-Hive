//
//  CustomGameTableViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 22.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

private let segueIdentifier = "showGameLoadingViewController"

class CustomGameTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // Row 1
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Row 2
    @IBOutlet weak var errorLabel: UILabel!
    
    // Row 3
    @IBOutlet weak var containsPangram: UILabel!
    @IBOutlet weak var containsPangramExplanation: UILabel!
    @IBOutlet weak var containsPangramSwitch: UISwitch!
    
    // Row 4
    @IBOutlet weak var centerLetterLabel: UILabel!
    @IBOutlet weak var centerLetterTextField: UITextField!
    @IBOutlet weak var centerLetterRandomButton: UIButton!
    
    // Row 5
    @IBOutlet weak var otherLettersLabel: UILabel!
    @IBOutlet weak var otherLettersTextField: UITextField!
    @IBOutlet weak var otherLettersRandomButton: UIButton!
    
    // Row 6
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var maxTimeAmountLabel: UILabel!
    @IBOutlet weak var maxTimeSwitch: UISwitch!
    
    // Row 7
    @IBOutlet weak var timeAmountPickerView: UIPickerView!
    @IBOutlet weak var timeKindPickerView: UIPickerView!
    
    // Row 8
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var germanLanguageLabel: UILabel!
    @IBOutlet weak var englishLanguageLabel: UILabel!
    @IBOutlet weak var germanLanguageButton: UIButton!
    @IBOutlet weak var englishLanguageButton: UIButton!
    
    // Row 9
    @IBOutlet weak var createCustomGameButton: UIButton!
    
    private let diceImages = [UIImage(named: "Dice One"), UIImage(named: "Dice Two"), UIImage(named: "Dice Three"), UIImage(named: "Dice Four"), UIImage(named: "Dice Five"), UIImage(named: "Dice Six")]
    
    private var checkBoxImages = [UIImage(named: "Checkbox Empty")!, UIImage(named: "Checkbox Filled")!]
    
    private var centerLetter = "" {
        didSet {
            print(centerLetter)
        }
    }
    private var otherLetters = [String]() {
        didSet {
            print(otherLetters)
        }
    }
    
    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    private let vowels = ["A", "E", "I", "O", "U"]
    
    private var normalTextFieldColor = UIColor.systemGray
    
    private var minutes = Array(1...59)
    private var hours = Array(1...23)
    private var days = Array(1...31)
    
    private let maxTimeStandardString = NSLocalizedString("take your time and relax", comment: "max Time Description when the user has an infinite amount of time in the Custom Game View Controller")
    
    private let minutesStringPlural = NSLocalizedString("minutes", comment: "minutes in the pickerView in the custom game view controller")
    private let minutesStringSingular = NSLocalizedString("minute", comment: "minute in the pickerView in the custom game view controller")
    private let hoursStringPlural = NSLocalizedString("hours", comment: "hours in the pickerView in the custom game view controller")
    private let hoursStringSingular = NSLocalizedString("hour", comment: "hour in the pickerView in the custom game view controller")
    private let daysStringPlural = NSLocalizedString("days", comment: "days in the pickerView in the custom game view controller")
    private let daysStringSingular = NSLocalizedString("day", comment: "day in the pickerView in the custom game view controller")
    
    // error messages
    private let onlyLettersMessage = NSLocalizedString("Only enter letters", comment: "Only enter letters error message in the custom game view controller")
    private let doubleLettersMessage = NSLocalizedString("Every letter can only appear once in the game", comment: "Double letter error message in the custom game view controller")
    private let missingFields = NSLocalizedString("Please fill out all the fields", comment: "Fields missing error message in the custom game view controller")
    private let missingVowels = NSLocalizedString("You need at least one vowel to play the game", comment: "Missing vowels error message in the custom game view controller")
    
    private var timeAmount = 1
    private var timeKind = ""
    
    private var pangramWords = [String]()
    private var pangram = ""
    private var currentCenterLetter = ""
    private var currentOtherLetters = ""
    private var maxTime = 0
    private var currentLanguage: Language = .german {
        didSet {
            if currentLanguage == .english {
                englishLanguageButton.setImage(checkBoxImages[1], for: .normal)
                englishLanguageButton.setImage(checkBoxImages[1], for: .highlighted)
                germanLanguageButton.setImage(checkBoxImages[0], for: .normal)
                germanLanguageButton.setImage(checkBoxImages[0], for: .highlighted)
            } else if currentLanguage == .german {
                englishLanguageButton.setImage(checkBoxImages[0], for: .normal)
                englishLanguageButton.setImage(checkBoxImages[0], for: .highlighted)
                germanLanguageButton.setImage(checkBoxImages[1], for: .normal)
                germanLanguageButton.setImage(checkBoxImages[1], for: .highlighted)
            }
            
            containsPangramSwitchPressed(germanLanguageButton!)
        }
    }
    
//    private var game: SpellingBeeGame!
    private var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        hideKeyboardWhenTapped()
        setupTableViewContent()
        
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        centerLetterTextField.addTarget(self, action: #selector(centerLetterTextFieldHasChanged), for: .editingChanged)
        otherLettersTextField.addTarget(self, action: #selector(otherLettersTextFieldHasChanged), for: .editingChanged)
        
        centerLetterTextField.delegate = self
        otherLettersTextField.delegate = self
        
        // gets pangrams from file
//        pangramWords = BeeHive.getPangrams(language: currentLanguage)
        
        randomDiceButtonImage(button: centerLetterRandomButton)
        randomDiceButtonImage(button: otherLettersRandomButton)
        
        timeAmountPickerView.tag = 0
        timeKindPickerView.tag = 1
        
        timeAmountPickerView.alpha = 0
        timeKindPickerView.alpha = 0
        
        timeAmountPickerView.delegate = self
        timeAmountPickerView.dataSource = self
        
        timeKindPickerView.delegate = self
        timeKindPickerView.dataSource = self
        
        timeKind = minutesStringSingular
        
        currentLanguage = Defaults.currentStandardLanguage()
    }
    
    func setupTableViewContent() {
        
        titleLabel.text = NSLocalizedString("Custom Game", comment: "Custom Game title in the Custom Game View Controller")
        containsPangram.text = NSLocalizedString("Contains pangram", comment: "Contains pangram label in the Custom Game View Controller")
        containsPangramExplanation.text = NSLocalizedString("a word that contains all letters", comment: "pangram explanation label in the Custom Game View Controller")
        centerLetterLabel.text = NSLocalizedString("Center Letter", comment: "Center Letter label in the Custom Game View Controller")
        otherLettersLabel.text = NSLocalizedString("Other Letters", comment: "Other Letters label in the Custom Game View Controller")
        maxTimeLabel.text = NSLocalizedString("max. Time", comment: "max Time label in the Custom Game View Controller")
        languageLabel.text = NSLocalizedString("Language", comment: "language label in the Custom Game View Controller")
        englishLanguageLabel.text = NSLocalizedString("English", comment: "English language label in the Custom Game View Controller")
        germanLanguageLabel.text = NSLocalizedString("German", comment: "German language label in the Custom Game View Controller")
        maxTimeAmountLabel.text = maxTimeStandardString
        
        centerLetterTextField.textColor = normalTextFieldColor
        otherLettersTextField.textColor = normalTextFieldColor
        
        errorLabel.alpha = 0
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        
        createCustomGameButton.layer.cornerRadius = createCustomGameButton.frame.height / 2
        createCustomGameButton.setTitle(NSLocalizedString("Create Custom Game", comment: "Create Custom Game Button in Custom Game View Controller"), for: .normal)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func containsPangramSwitchPressed(_ sender: Any) {
        
        if containsPangramSwitch.isOn {
            
            centerLetterRandomButton.isEnabled = false
            otherLettersRandomButton.isEnabled = false
            
            // gets a random pangram
            
            pangramWords = BeeHive.getPangrams(language: currentLanguage)
            
            pangram = pangramWords.shuffled()[0]
            
            // get different letters
            var shuffledPangram = BeeHive.getDifferentLetters(string: pangram)
            
            let pangramCenterLetter = shuffledPangram[0]
            
            centerLetterTextField.text = pangramCenterLetter
            centerLetter = pangramCenterLetter
            
            shuffledPangram.remove(at: 0)
            
            otherLettersTextField.text = ""
            otherLettersTextField.text?.append(shuffledPangram[0])
            
            otherLetters = []
            otherLetters.append(String(shuffledPangram[0]))
            
            for i in 1...5 {
                otherLettersTextField.text? += " "
                otherLettersTextField.text?.append(shuffledPangram[i])
                
                otherLetters.append(shuffledPangram[i])
            }
        } else {
            
            centerLetterRandomButton.isEnabled = true
            otherLettersRandomButton.isEnabled = true
            
            if let _ = sender as? UIButton { // checks if function is called due to the user tapping a language button or the pangram button
                return
            } else {
                centerLetterTextField.text = ""
                otherLettersTextField.text = ""
                
                centerLetter = ""
                otherLetters = []
            }
        }
    }
    
    @IBAction func centerLetterRandomButtonPressed(_ sender: Any) {
        
        randomDiceButtonImage(button: centerLetterRandomButton)
        
        randomTextFieldContent(textField: centerLetterTextField, singleLetter: true)
    }
    
    @objc func centerLetterTextFieldHasChanged() {
        
        if let centerLetterTextFieldText = centerLetterTextField.text?.uppercased() {
            
            centerLetterTextField.text = centerLetterTextFieldText // make text uppercased
                        
            if centerLetterTextField.text!.count > 1 {
                centerLetterTextField.deleteBackward() // deletes last letter if text.count > 1
            }
            
            if centerLetterTextFieldText.count == 1 {
                if alphabet.contains(centerLetterTextFieldText) == false {
                    textFieldError(textField: centerLetterTextField)
                    displayErrorLabel(message: onlyLettersMessage)
                } else if otherLetters.contains(centerLetterTextFieldText) {
                    textFieldError(textField: centerLetterTextField)
                    displayErrorLabel(message: doubleLettersMessage)
                } else {
                    textFieldNormal(textField: centerLetterTextField)
                    centerLetter = centerLetterTextFieldText
                    print("We have a center letter")
                    return
                }
            }
            
            centerLetter = ""
        }
        
        containsPangramSwitch.setOn(false, animated: true)
    }
    
    @IBAction func otherLettersRandomButtonPressed(_ sender: Any) {
        
        randomDiceButtonImage(button: otherLettersRandomButton)
        
        randomTextFieldContent(textField: otherLettersTextField, singleLetter: false)
    }
    
    @objc func otherLettersTextFieldHasChanged() {
        
        if let otherLettersTextFieldText = otherLettersTextField.text?.uppercased() {
            
            otherLettersTextField.text = otherLettersTextFieldText // make text uppercased
            
            if otherLettersTextFieldText.count > 11 {
                otherLettersTextField.deleteBackward() // deletes last letter if text.count > 11
            }
            
            for letter in otherLettersTextFieldText {
                
                let expandedAlphabet = alphabet + [" "]
                
                if expandedAlphabet.contains(String(letter)) == false { // error if text contains any letters but the alphabet and " "
                    textFieldError(textField: otherLettersTextField)
                    displayErrorLabel(message: onlyLettersMessage)
                } else if centerLetter == String(letter) {
                    textFieldError(textField: otherLettersTextField)
                    displayErrorLabel(message: doubleLettersMessage)
                } else {
                    textFieldNormal(textField: otherLettersTextField)
                }
                
            }
            
            if otherLettersTextFieldText.count >= 2 && otherLettersTextFieldText.count < 12 {
                
                for letterPosition in 0...otherLettersTextFieldText.count - 2 {
                    
                    if alphabet.contains(String(otherLettersTextFieldText[otherLettersTextFieldText.index(otherLettersTextFieldText.startIndex, offsetBy: letterPosition)])) && alphabet.contains(String(otherLettersTextFieldText[otherLettersTextFieldText.index(otherLettersTextFieldText.startIndex, offsetBy: letterPosition + 1)])) {
                        
                        var currentText = otherLettersTextField.text!
                        currentText.insert(" ", at: currentText.index(currentText.startIndex, offsetBy: letterPosition + 1))
                        otherLettersTextField.text = currentText
                        
                    }
                }
            }
            
            currentOtherLetters =  otherLettersTextField.text!.replacingOccurrences(of: " ", with: "")
                        
            for letter in currentOtherLetters {
                
                var occurenceCount = 0
                
                for secondRoundLetter in currentOtherLetters {
                    if secondRoundLetter == letter {
                        print(letter)
                        occurenceCount += 1
                    }
                }
                                
                if occurenceCount >= 2 {
                    textFieldError(textField: otherLettersTextField)
                    displayErrorLabel(message: doubleLettersMessage)
                }
            }
            
            if currentOtherLetters.count == 6 {
                var otherLettersArray = [String]()
                for letter in currentOtherLetters {
                    otherLettersArray.append(String(letter))
                }
                
                otherLetters = otherLettersArray
                
                return
            }
            
            otherLetters = []
            
        }
        
        containsPangramSwitch.setOn(false, animated: true)
    }
    
    @IBAction func maxTimeSwitchPressed(_ sender: Any) {
        
        if maxTimeSwitch.isOn == false {
            maxTime = 0
            
            maxTimeAmountLabel.text = maxTimeStandardString
            UIView.animate(withDuration: 0.3, animations: {
                self.timeKindPickerView.alpha = 0
                self.timeAmountPickerView.alpha = 0
            }) { (true) in
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        } else if maxTimeSwitch.isOn {
            if maxTime == 0 {
                maxTime = 60
            }
            maxTimeAmountLabel.text = "\(timeAmount) \(timeKind)"
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.animate(withDuration: 0.3, delay: 0.3, options: [], animations: {
                self.timeKindPickerView.alpha = 1
                self.timeAmountPickerView.alpha = 1
            }) { (true) in
                //
            }
        }
    }
    
    @IBAction func checkBoxBtnPressed(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if button.image(for: .normal) == checkBoxImages[0] {
                if button == germanLanguageButton {
                    currentLanguage = .german
                } else if button == englishLanguageButton {
                    currentLanguage = .english
                }
            }
        }
        
        
    }
    
    @IBAction func createCustomGameButtonPressed(_ sender: Any) {
        
        // check all the fields
        
        if containsPangramSwitch.isOn == false {
            
            if centerLetter == "" || otherLetters == [] {
                displayErrorLabel(message: missingFields)
                return
            } else if containsVowels(string: centerLetter) == false && containsVowels(string: currentOtherLetters) == false {
                displayErrorLabel(message: missingVowels)
                return
            }
            
        }
        
        // perform Segue
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    // MARK: - Functions
    
    func randomDiceButtonImage(button: UIButton, duration: Double = 0.3) {
        
        let currentButtonImage = button.imageView!.image!
        var foundNewImage = false
        var newImage: UIImage!
        
        while foundNewImage == false {
            
            newImage = diceImages.shuffled()[0]
            if newImage != currentButtonImage {
                foundNewImage = true
            } else {
                foundNewImage = false
            }
        }
        
        UIView.animate(withDuration: duration, animations: {
            button.alpha = 0
        }) { (true) in
            
            button.setImage(newImage, for: .normal)
            button.setImage(newImage, for: .highlighted)
            
            UIView.animate(withDuration: duration) {
                button.alpha = 1
            }
        }
    }
    
    func randomTextFieldContent(textField: UITextField, singleLetter: Bool, duration: Double = 0.3) {
        
        var newText = ""
        
        if singleLetter == true { // center letter creation
            
            if containsVowels(string: currentOtherLetters) == false { // creates a vowel for the center letter
                
                repeat {
                    newText = getRandomVowel()
                } while newText == centerLetter
                
                centerLetter = newText
                
            } else { // creates anything else for the center letter
                
                repeat {
                    newText = createRandomLetters(amount: 1)
                    centerLetter = newText
                } while currentOtherLetters.contains(centerLetter) || otherLetters.contains(centerLetter)
                
            }
            
        } else { // other letters creation
            
            if containsVowels(string: centerLetter) || centerLetter == "" { // creates anything else
                
                repeat {
                    
                    otherLetters = []
                    newText = ""
                    currentOtherLetters = ""
                    
                    let shuffledAlphabet = alphabet.shuffled()
                    
                    for i in 0...5 {
                        
                        if i != 5 {
                            newText.append(shuffledAlphabet[i])
                            newText.append(" ")
                        } else {
                            newText.append(shuffledAlphabet[i])
                        }
                        
                        otherLetters.append(shuffledAlphabet[i])
                        currentOtherLetters += shuffledAlphabet[i]
                        
                    }
                    
                } while otherLetters.contains(centerLetter) || containsLetterMoreThanOnce(string: currentOtherLetters)
                
            } else { // adds at least one vowel
                                
                repeat {
                    
                    currentOtherLetters = ""
                    otherLetters = []
                    newText = ""
                    
                    let vowelCharacter = getRandomVowel()
                    let otherString = createRandomLetters(amount: 5)
                    
                    newText.append(vowelCharacter)
                    currentOtherLetters += vowelCharacter
                    otherLetters.append(vowelCharacter)
                    
                    for character in otherString {
                        
                        newText.append(" ")
                        newText.append(character)
                        
                        otherLetters.append(String(character))
                        currentOtherLetters += String(character)
                        
                    }
                    
                } while otherLetters.contains(centerLetter) || containsLetterMoreThanOnce(string: currentOtherLetters)
            }
        }
        
        
        UIView.animate(withDuration: duration, animations: {
            textField.alpha = 0
        }) { (true) in
            
            textField.text = newText
            
            UIView.animate(withDuration: duration) {
                textField.alpha = 1
            }
        }
        
    }
    
    func textFieldError(textField: UITextField) {
        
        textField.textColor = .red
        
        textField.transform = CGAffineTransform(translationX: 7, y: 0)
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: CGFloat(textField.text!.count) * 0.02, initialSpringVelocity: 1, options: [], animations: {
            textField.transform = CGAffineTransform.identity
        }) { (true) in
            
        }
    }
    
    func textFieldNormal(textField: UITextField) {
        
        textField.textColor = normalTextFieldColor
    }
    
    func displayErrorLabel(message: String, duration: Double = 0.3, delay: Double = 1) {
        
        errorLabel.text = message
        
        UIView.animate(withDuration: duration, animations: {
            self.errorLabel.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
                self.errorLabel.alpha = 0
            }, completion: nil)
        }
    }
    
    func containsVowels(string: String) -> Bool {
        
        for letter in string {
            if vowels.contains(String(letter)) {
                return true
            }
        }
        
        return false
    }
    
    func containsLetterMoreThanOnce(string: String) -> Bool {
        
        var letterCounter = 0
        
        for firstLetter in string {
            letterCounter = 0
            for secondLetter in string {
                if firstLetter == secondLetter {
                    letterCounter += 1
                }
            }
            
            if letterCounter >= 2 {
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func createRandomLetters(amount: Int) -> String {
        
        let shuffledAlphabet = alphabet.shuffled()
        var string = ""
        
        for i in 1...amount {
            string += shuffledAlphabet[i - 1]
        }
        
        return string
    }
    
    func getRandomVowel() -> String {
        
        return vowels.shuffled()[0]
        
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // hides keyboard when the return button was tapped
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Picker view data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 { // Time Amount
            if timeKindPickerView.selectedRow(inComponent: 0) == 0 { // Minutes
                return minutes.count
            } else if timeKindPickerView.selectedRow(inComponent: 0) == 1 { // Hours
                return hours.count
            } else {
                return days.count
            }
        } else if pickerView.tag == 1 { // Time Kind
            return 3
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == timeAmountPickerView { // Time Amount
            if timeKindPickerView.selectedRow(inComponent: 0) == 0 { // Minutes
                return String(minutes[row])
            } else if timeKindPickerView.selectedRow(inComponent: 0) == 1 { // Hours
                return String(hours[row])
            } else {
                return String(days[row])
            }
        } else if pickerView.tag == 1 { // Time Kind
            if row == 0 {
                return minutesStringPlural
            } else if row == 1{
                return hoursStringPlural
            } else if row == 2 {
                 return daysStringPlural
            }
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeAmountPickerView.reloadAllComponents()
        
        if pickerView == timeAmountPickerView {
            timeAmount = row + 1
            if timeAmount == 1 {
                //make singular
                if timeKind == minutesStringPlural { // minutes
                    timeKind = minutesStringSingular
                    maxTime = 60
                } else if timeKind == hoursStringPlural { // hours
                    timeKind = hoursStringSingular
                    maxTime = 60 * 60
                } else if timeKind == daysStringPlural { // days
                    timeKind = daysStringSingular
                    maxTime = 60 * 60 * 24
                }
            } else {
                //make plural
                if timeKind == minutesStringSingular {
                    timeKind = minutesStringPlural
                    maxTime = 60 * timeAmount
                } else if timeKind == hoursStringSingular {
                    timeKind = hoursStringPlural
                    maxTime = 60 * 60 * timeAmount
                } else if timeKind == daysStringSingular {
                    timeKind = daysStringPlural
                    maxTime = 60 * 60 * 24 * timeAmount
                }
            }
        } else if pickerView == timeKindPickerView {
            if row == 0 { // minutes
                if timeAmount == 1 {
                    timeKind = minutesStringSingular
                    maxTime = 60
                } else {
                    timeKind = minutesStringPlural
                    maxTime = 60 * timeAmount
                }
            } else if row == 1 { // hours
                if timeAmount == 1 {
                    timeKind = hoursStringSingular
                    maxTime = 60 * 60
                } else {
                    timeKind = hoursStringPlural
                    maxTime = 60 * 60 * timeAmount
                }
            } else if row == 2 { // days
                if timeAmount == 1 {
                    timeKind = daysStringSingular
                    maxTime = 60 * 60 * 24
                } else {
                    timeKind = daysStringPlural
                    maxTime = 60 * 60 * 24 * timeAmount
                }
            }
        }
        
        maxTimeAmountLabel.text = "\(timeAmount) \(timeKind)"
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 && maxTimeSwitch.isOn == false {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let finalLanguage = currentLanguage
        
        if segue.identifier == segueIdentifier {
            
            if let destinationVC = segue.destination as? LoadingGameViewController {
                
                destinationVC.language = finalLanguage
                destinationVC.centerLetter = centerLetter
                destinationVC.otherLetters = otherLetters
                destinationVC.isDaily = false
//                destinationVC.game = game
                destinationVC.maxTime = maxTime
            }
        }
    }
    

}
