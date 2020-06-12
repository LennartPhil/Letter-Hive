//
//  SpellingBeeCollectionViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 18.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

private let gameCellReuseIdentifier = "SpellingBeeCell"
private let imageCellReuseIdentifier = "imageCollectionViewCell"

private let showSpellingBeeGameSegue = "showSpellingBeeGame"
private let customGameViewControllerSegue = "presentModallyCustomGameViewController"
private let loadingGameViewControllerSegue = "presentModallyLoadingGameViewController"
private let showSettingsSegue = "showSettings"

private let sectionInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
private let phoneItemsPerRow = 2
private let padItemsPerRow = 4

class SpellingBeeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ReloadCollectionViewContentDelegate, DismissGameVCDelegate {
    
    var moc: NSManagedObjectContext!
    
    private var games = [SpellingBeeGame]()
    private var dailies = [SpellingBeeGame]()
    private var others = [SpellingBeeGame]()
    
    private var timer = Timer()
    
    private var soloDailyisToday = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "Yellow")!]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Yellow")!]
        }
        
        dailies = []
        others = []
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        fetchGames()
        
        setupDailies()
        
        print("ALL GAMES-----------------------")
        print(games)
        print("ALL GAMES-----------------------")
        print("\n\n")
        
        print("DAILIES-------------------------")
        print(dailies)
        print("")
        print("OTHERS--------------------------")
        print(others)
        
        collectionView.delegate = self
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        
        navigationBarSetup()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.collectionView.reloadData()
        })
    }
    
    // MARK: - Dailies
    
    func setupDailies() {
        
//        dailies = dailies.sorted(by: { $0.dateAdded! > $1.dateAdded! }) // oldest is first now

        print("Dailies!\n\n\n\n")
        
        print(dailies)
        
        if dailies.count == 1 {
            if Calendar.current.isDateInToday(dailies[0].dateAdded!) {
                soloDailyisToday = true
            } else {
                soloDailyisToday = false
            }
        } else if dailies.count == 2 {
            
            var containsToday = false
            
            for game in dailies {
                if Calendar.current.isDateInToday(game.dateAdded!) {
                    containsToday = true
                }
            }
            
            if containsToday == false {
                removeGame(game: dailies[0])
                //dailies.remove(at: 0) not sure if I need this
            }
        } else if dailies.count > 2 {
            
            var containsToday = false
            
            for game in dailies {
                if Calendar.current.isDateInToday(game.dateAdded!) {
                    containsToday = true
                }
            }
            
            if containsToday {
                while dailies.count > 2 {
                    self.removeGame(game: dailies[0])
                    dailies.remove(at: 0)
                }
            } else {
                while dailies.count > 1 {
                    self.removeGame(game: dailies[0])
                    dailies.remove(at: 0)
                }
            }
        }
    }
    
    
    func fetchGames() {
        
        dailies = []
        others = []
        
        let gameRequest: NSFetchRequest<SpellingBeeGame> = SpellingBeeGame.fetchRequest()
        gameRequest.returnsObjectsAsFaults = false
        
        let isDailyDescriptor = NSSortDescriptor(key: "isDaily", ascending: false)
        gameRequest.sortDescriptors = [isDailyDescriptor]
        
        do {
            games = try moc.fetch(gameRequest)
        } catch {
            print(error)
        }
        
        for game in games {
            if game.isDaily {
                dailies.append(game)
            } else {
                others.append(game)
            }
        }
        
        dailies = dailies.sorted(by: { $0.dateAdded! < $1.dateAdded! }) // oldest is first now
        others = others.sorted(by: { $0.dateAdded! < $1.dateAdded! })
//        others = others.sorted(by: { $0.lastPlayed! > $1.lastPlayed! }) // youngest is first now
        
        collectionView.reloadData()
    }
    
    func removeGame(game: SpellingBeeGame) {
        moc.delete(game)
        fetchGames()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSpellingBeeGameSegue {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let destinationController = segue.destination as! GameViewController
                destinationController.delegate = self
                
                if indexPath.section == 0 { // Dailies
                    destinationController.finalGame = dailies[indexPath.row]
                } else { // Others
                    destinationController.finalGame = others[indexPath.row]
                }
            }
        } else if segue.identifier == loadingGameViewControllerSegue {
            
            let destinationController = segue.destination as! LoadingGameViewController
            
            destinationController.delegate = self
            
            destinationController.isDaily = true
            destinationController.maxTime = 86400
            destinationController.language = Defaults.currentStandardLanguage()
        }
    }
    
    
    // MARK: - Navigation Bar Setup
    
    func navigationBarSetup() {
        //hides the navigationbar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "Yellow")
        
        //creates question mark Button on the upper right corner
        let customButton = UIButton()
        customButton.setImage(UIImage(named: "Settings Button"), for: .normal)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = Colors.navigationBarButtonColor
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            customButton.heightAnchor.constraint(equalToConstant: 35),
            customButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        let rightBarbutton = UIBarButtonItem(customView: customButton)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    @objc func settingsButtonPressed() {
        vibration.lightVibration()
        performSegue(withIdentifier: showSettingsSegue, sender: self)
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            if dailies.count >= 2 {
                return dailies.count
            } else {
                if soloDailyisToday {
                    return dailies.count
                } else {
                    return dailies.count + 1
                }
            }
        } else {
            return others.count + 1
        }
    }
    
    // MARK: - Cells

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 { // Daily Games
            
            if indexPath.row <= dailies.count - 1 {
                
                if dailies.isEmpty == false {
                    return generateSpellingBeeGameCell(indexPath: indexPath, sectionGames: dailies)
                }
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageCollectionViewCell
            
            let templateImage = UIImage(named: "Questionmark")!.withRenderingMode(.alwaysTemplate)
            cell.cellImageView.image = templateImage
            cell.cellImageView.tintColor = UIColor(named: "Gray")
            
            cell.tag = 2
            
            return cell
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == others.count { // Add Game Cell

                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellReuseIdentifier, for: indexPath) as! ImageCollectionViewCell

                let templateImage = UIImage(named: "Add button")!.withRenderingMode(.alwaysTemplate)
                cell.cellImageView.image = templateImage
                cell.cellImageView.tintColor = UIColor(named: "Gray")
                
                cell.tag = 1
                
                return cell
                
            } else {
                return generateSpellingBeeGameCell(indexPath: indexPath, sectionGames: others)
            }
            
        }
        
        return SpellingBeeCollectionViewCell()
        
    }
    
    func generateSpellingBeeGameCell(indexPath: IndexPath, sectionGames: [SpellingBeeGame]) -> SpellingBeeCollectionViewCell {
        
        let game = sectionGames[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameCellReuseIdentifier, for: indexPath) as! SpellingBeeCollectionViewCell
        
        cell.tag = 0
        
        let gameRanking = Ranking.getRanking(percentage: Ranking.getPercentage(foundWords: game.guessedWords!, correctWords: game.correctWords!))
        
        var dateAdded = Date()
        
        cell.isDaily = game.isDaily
        
        cell.contentSize = cell.contentView.frame.size
        
        if let date = game.dateAdded {
            cell.dateAdded = date
            dateAdded = date
        } else {
            print("date equals nil")
        }
        
        if game.isDaily == false { // Other Games
            
            cell.hexagonsView.alpha = 1
            
            let maxTime = Int(game.maxTime)
            if maxTime == 0 { // no max Time
                cell.textLabel.text = gameRanking
            } else { // max. Time has Value
                
                let remainingTime = RemainingTime.getRemainingTimeString(dateAdded: dateAdded, maxTime: maxTime)
                
                cell.textLabel.text = remainingTime.0
                
                if remainingTime.1 == true {
                    cell.hexagonsView.alpha = 0.5
                } else {
                    cell.hexagonsView.alpha = 1
                }
                
            }
        } else if cell.isDaily! { // Dailies
            
            if Calendar.current.isDateInToday(dateAdded) {
                cell.hexagonsView.alpha = 1
                
                cell.textLabel.text = NSLocalizedString("Today", comment: "Today label Dailies CollectionVC")
            } else {
                cell.hexagonsView.alpha = 0.5
                
                if Calendar.current.isDateInYesterday(dateAdded) {
                    cell.textLabel.text = NSLocalizedString("Yesterday", comment: "Yesterday label Dailies CollectionVC")
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM, yy"
                    let dateString = dateFormatter.string(from: dateAdded)
                    cell.textLabel.text = dateString
                }
            }
        }
        
        if game.isNew {
            cell.contentView.backgroundColor = UIColor(named: "Dark Yellow")
        } else {
            cell.contentView.backgroundColor = UIColor(named: "Light White")
        }
        
        if game.language == "German" {
            cell.languageLabel.text = NSLocalizedString("DE", comment: "German label in the spelling bee collection view game cell")
        } else if game.language == "English" {
            cell.languageLabel.text = NSLocalizedString("EN", comment: "German label in the spelling bee collection view game cell")
        } else {
            cell.languageLabel.text = "en"
        }
        
        if let cellLetters = game.letters {
            cell.letters = cellLetters
        } else {
            print("letters equals nil")
        }
        
        cell.contentSize = cell.contentView.frame.size
        cell.adjustButtonFontSize()
        
        return cell
    }
    
    
    // MARK: - Headers
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerIdentifier", for: indexPath) as? HeaderCollectionReusableView else {
                fatalError("Invalid headerview type of collectionview")
            }
            
            if indexPath.section == 0 {
                headerView.headerLabel.text = NSLocalizedString("Daily", comment: "Daily games section")
            } else {
                headerView.headerLabel.text = NSLocalizedString("Custom Games", comment: "Custom games section")
            }
            
            return headerView
                
        default:
            
            assert(false, "Invalid element type of collection view")
            
        }
        
        return UICollectionReusableView()
    }

    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            if let imageCollectionViewCell = cell as? ImageCollectionViewCell {
                
                if imageCollectionViewCell.tag == 1 {
                    
                    performSegue(withIdentifier: customGameViewControllerSegue, sender: self)
                } else if imageCollectionViewCell.tag == 2 {
                    
                    performSegue(withIdentifier: loadingGameViewControllerSegue, sender: self)
                } else {
                    print("Couldn't differentiate between the two cells")
                }
            } else {
                print("Couldn't cast cell as Image Collection View Cell")
            }
        } else {
            print("Couldn't get cell at indexPath")
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    func getCellSize() -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            let width = self.view.frame.width

            let insets = Int(sectionInsets.left) * (phoneItemsPerRow + 1)
            let finalWidth = (Int(width) - insets) / phoneItemsPerRow

            return CGSize(width: finalWidth, height: finalWidth)
            
        } else {
            
            let width = self.view.frame.width

            let insets = Int(sectionInsets.left) * (padItemsPerRow + 1)
            let finalWidth = (Int(width) - insets) / padItemsPerRow

            return CGSize(width: finalWidth, height: finalWidth)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return getCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    // MARK: - Relaod Collection View Delegate
    
    func reloadCollectionViewContent() {
        
//        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        dailies = []
//        others = []
//
//        let gameRequest: NSFetchRequest<SpellingBeeGame> = SpellingBeeGame.fetchRequest()
//        gameRequest.returnsObjectsAsFaults = false
//
//        let isDailyDescriptor = NSSortDescriptor(key: "isDaily", ascending: false)
//        gameRequest.sortDescriptors = [isDailyDescriptor]
//
//        //        let lastPlayedDescripter = NSSortDescriptor(key: "lastPlayed", ascending: true)
//        //        gameRequest.sortDescriptors = [lastPlayedDescripter]
//
//        do {
//            games = try moc.fetch(gameRequest)
//        } catch {
//            print(error)
//        }
//
//        for game in games {
//            if game.isDaily {
//                dailies.append(game)
//            } else {
//                others.append(game)
//            }
//        }
//
//        collectionView.reloadData()
        
        fetchGames()
        
        setupDailies()
        
        collectionView.reloadData()
    }
    
    
    @IBAction func goBackToCollectionView(segue: UIStoryboardSegue) {
//        reloadCollectionViewContent()
        fetchGames()
    }
    
}
