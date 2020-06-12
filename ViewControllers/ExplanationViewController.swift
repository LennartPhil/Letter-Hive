//
//  ExplanationViewController.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 08.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ExplanationViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var explanationView: UIView!
    @IBOutlet weak var explanationTextView: UITextView!
    
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonRoundedCornersView: UIView!
    @IBOutlet weak var deleteGameButton: UIButton!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    let label = UILabel()
    let deleteButton = CustomButton()
    let cancelButton = CustomButton()
    let stackView = UIStackView()
    
    let buttonViewCornerRadius: CGFloat = 15
    
    var game: SpellingBeeGame!
    
    var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
//        buttonRoundedCornersView.roundCorners(corners: [.topLeft, .topRight], radius: buttonViewCornerRadius)
        buttonRoundedCornersView.layer.cornerRadius = buttonViewCornerRadius
        buttonRoundedCornersView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        buttonRoundedCornersView.backgroundColor = UIColor(named: "Light White")
        
        setupButtonView()
        
        deleteGameButton.backgroundColor = .red
        deleteGameButton.setTitle(NSLocalizedString("Delete game", comment: "Delete gam button in the explanation view controller"), for: .normal)
        deleteGameButton.setTitleColor(.white, for: .normal)
        deleteGameButton.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 20)
        
        deleteGameButton.layer.cornerRadius = buttonViewCornerRadius
        deleteGameButton.clipsToBounds = true
        
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        
        // Dark Mode
        
        if self.traitCollection.userInterfaceStyle == .dark { // Dark
            if #available(iOS 13.0, *) {
                visualEffectView.effect = UIBlurEffect(style: .systemThinMaterialDark)
            } else {
                visualEffectView.effect = UIBlurEffect(style: .dark)
            }
            
        } else { // White
            if #available(iOS 13.0, *) {
                visualEffectView.effect = UIBlurEffect(style: .systemMaterialLight)
            } else {
                visualEffectView.effect = UIBlurEffect(style: .light)
            }
            
        }
        
        explanationView.layer.cornerRadius = buttonViewCornerRadius
        explanationView.clipsToBounds = true
        explanationView.backgroundColor = UIColor(named: "Light White")
        
        explanationTextView.backgroundColor = UIColor.clear
        
        setupExplanationTextView()
        
        if game.isDaily == true {
            
            buttonView.isHidden = true
            
        }
    }
    
    func setupButtonView() {
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttonView.layer.backgroundColor = UIColor.clear.cgColor
        buttonView.layer.shadowRadius = 5
        buttonView.layer.shadowOpacity = 1
        
        if self.traitCollection.userInterfaceStyle == .dark {
            buttonView.layer.shadowColor = UIColor.black.cgColor
        } else {
            buttonView.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
    
    func setupExplanationTextView() {
        
        explanationTextView.attributedText = NSAttributedString(string: "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
                
        let headerText = NSLocalizedString("How to play", comment: "How to play text in the explanation view controller")
        let headerAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "Yellow"),
            NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 20)]
        let headerAttributedString = NSMutableAttributedString(string: headerText, attributes: headerAttributes as [NSAttributedString.Key : Any])
        
        let subheaderText = NSLocalizedString("\n\nCreate words using letters from the hive", comment: "Subheader text in the explanation view controller")
        let subheaderAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: explanationTextView.font!.pointSize, weight: .bold),
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black")]
        let subheaderAttributedString = NSAttributedString(string: subheaderText, attributes: subheaderAttributes as [NSAttributedString.Key : Any])
        
        let contentText = NSLocalizedString("\n\n- Words must contain at least 4 letters\n- Words must include the center letter\n- Letters can be used more than once\n- the percentage is based on the total amount of letters\n- daily games can be played until the day is over and always contain at least one pangram", comment: "content text in the explanation controller")
        let contentAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: explanationTextView.font!.pointSize),
            NSAttributedString.Key.paragraphStyle : paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor(named: "Black")]
        let contentAttributedString = NSAttributedString(string: contentText, attributes: contentAttributes as [NSAttributedString.Key : Any])
        
        
        headerAttributedString.append(subheaderAttributedString)
        headerAttributedString.append(contentAttributedString)
        
        explanationTextView.attributedText = headerAttributedString
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteGameBtnPressed(_ sender: Any) {
        
        label.text = NSLocalizedString("Are you sure?", comment: "Are you sure question when game is deleted in Explanation VC")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Bold", size: 20)
        label.textAlignment = .center
        label.alpha = 0
        
        deleteButton.setTitle(NSLocalizedString("Delete", comment: "Delete game in Explanation VC"), for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 20)
        deleteButton.addTarget(self, action: #selector(deleteGame), for: .touchUpInside)
        deleteButton.layer.cornerRadius = buttonViewCornerRadius
        deleteButton.clipsToBounds = true
        
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel deletion in Explanation VC"), for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = Colors.systemGray3
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 20)
        cancelButton.addTarget(self, action: #selector(cancelDeletion), for: .touchUpInside)
        cancelButton.layer.cornerRadius = buttonViewCornerRadius
        cancelButton.clipsToBounds = true
        
        stackView.addArrangedSubview(deleteButton)
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

            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.deleteGameButton.alpha = 0
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
    
    @objc func deleteGame() {
        
        moc.delete(game)
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
        performSegue(withIdentifier: "backToCollectionViewFromExplanationVC", sender: self)
    }
    
    @objc func cancelDeletion() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.label.alpha = 0
            self.stackView.alpha = 0
        }) { (true) in
            self.label.removeFromSuperview()
            self.stackView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                self.buttonViewHeight.constant = 130
                self.view.layoutIfNeeded()
            }) { (true) in
                //vibration.lightVibration()

                UIView.animate(withDuration: 0.3) {
                    self.deleteGameButton.alpha = 1
                }
                
            }
        }
    }
    
    // MARK: - Email
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        vibration.lightVibration()
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["letterhive.app@gmail.com"])
            mail.setMessageBody(NSLocalizedString("<p>I think that you missed some words...<br>You should add the following words:<br><p>", comment: "Mail Message Body in HTML in the explanation view controller"), isHTML: true)
            mail.setSubject(NSLocalizedString("Missing Letter Hive Words", comment: "Mail Subject in the explanation view controller"))
            
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
    
    // MARK: - Dark Mode
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.userInterfaceStyle == .dark { // Dark
            if #available(iOS 13.0, *) {
                visualEffectView.effect = UIBlurEffect(style: .systemThinMaterialDark)
            } else {
                visualEffectView.effect = UIBlurEffect(style: .dark)
            }
        } else { // Light
            if #available(iOS 13.0, *) {
                visualEffectView.effect = UIBlurEffect(style: .systemMaterialLight)
            } else {
                visualEffectView.effect = UIBlurEffect(style: .light)
            }
        }
        
        setupExplanationTextView()
        setupButtonView()
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
