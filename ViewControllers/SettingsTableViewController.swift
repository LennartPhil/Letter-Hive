//
//  SettingsTableViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 11.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import MessageUI

private let changeLanguageVCIdentifier = "showChangeLanguageTableVC"

class SettingsTableViewController: UITableViewController, UIActivityItemSource, MFMailComposeViewControllerDelegate, UpdateStandardLanguageDelegate {
    
    @IBOutlet weak var nytHeaderLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var defaultLanguageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "Yellow")!]
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Yellow")!]
        }
        
        tableViewContentSetup()
        
        navigationBarSetup()
    }
    
    func tableViewContentSetup() {
        
        nytHeaderLabel.text = NSLocalizedString("This game was inspired by the New York Times game Spelling Bee", comment: "NYTimes game message in SettingsVC")
        
        setDefaultLanguageLabelText()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.appVersionLabel.text = version
        }
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.appVersionLabel.text! += " (\(build))"
        }
        
        languageLabel.text = DeviceLanguage.translatedLanguage(language: DeviceLanguage.deviceLanguage())
    }
    
    func navigationBarSetup() {
        //hides the navigationbar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "Yellow")
        
        //creates question mark Button on the upper right corner
        let customButton = UIButton()
        customButton.setImage(UIImage(named: "Close Button"), for: .normal)
        customButton.imageView?.contentMode = .scaleAspectFit
        customButton.tintColor = Colors.navigationBarButtonColor
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        NSLayoutConstraint.activate([
            customButton.heightAnchor.constraint(equalToConstant: 35),
            customButton.widthAnchor.constraint(equalToConstant: 35)
        ])
        
        let rightBarbutton = UIBarButtonItem(customView: customButton)
        self.navigationItem.rightBarButtonItem = rightBarbutton
    }
    
    @objc func dismissViewController() {
        vibration.lightVibration()
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.reuseIdentifier == "review" {
                // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
                //                   1513817372
                //       You can find the App Store ID in your app's product URL
                
                if let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1513817372?action=write-review") {
                    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                } else {
                    Warnings.presentAlert(with: NSLocalizedString("Failed to connect to AppStore", comment: "Review failure alert title"), and: NSLocalizedString("Maybe you should try again later", comment: "Reivew failure alert message"), in: self)
                }
            } else if cell.reuseIdentifier == "share" {
                
                let items: [Any] = [NSLocalizedString("Hey, check out this cool app :)", comment: "App Sharing message"), URL(string: "https://itunes.apple.com/app/id1513817372?)")!]
                
                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                present(activityVC, animated: true, completion: nil)
            } else if cell.reuseIdentifier == "feedback" {
                
                sendEmail()
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["letterhive.app@gmail.com"])
            mail.setMessageBody(NSLocalizedString("<p>Here are some things that I liked:<br><br>Here are some things that you can improve:<p>", comment: "Mail Message Body in HTML in the Settings view controller"), isHTML: true)
            mail.setSubject(NSLocalizedString("Letter Hive Feedback", comment: "Mail Subject in the Settings view controller"))
            
            mail.navigationBar.tintColor = UIColor(named: "Yellow")
            
            present(mail, animated: true, completion: nil)
        } else {
            Warnings.presentAlert(with: NSLocalizedString("No e-mail account", comment: "No e-mail account alter title"), and: NSLocalizedString("It seems like there's no e-mail account setup in your settings", comment: "No e-mail account alter message"), in: self)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("Did finish E-Mail stuff")
    }
    
    // MARK: - Activity VC Functions
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return [NSLocalizedString("Hey, check out this cool app :)", comment: "App Sharing message"), URL(string: "https://itunes.apple.com/app/id1513817372?)")!]
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == UIActivity.ActivityType.postToTwitter {
            return [NSLocalizedString("Hey, check out this cool #App #LetterHive", comment: "Twitter App Sharing message"), URL(string: "https://itunes.apple.com/app/id1513817372?)")!]
        } else {
            return [NSLocalizedString("Hey, check out this cool app :)", comment: "App Sharing message"), URL(string: "https://itunes.apple.com/app/id1513817372?)")!]
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Letter Hive App"
    }
    
    
    func setDefaultLanguageLabelText() {
        defaultLanguageLabel.text = DeviceLanguage.translatedLanguage(language: Defaults.currentStandardLanguage())
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == changeLanguageVCIdentifier {
            let destinationVC = segue.destination as! ChangeLanguageTableViewController
            destinationVC.delegate = self
        }
    }
}
