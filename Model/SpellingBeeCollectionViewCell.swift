//
//  SpellingBeeCollectionViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 18.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class SpellingBeeCollectionViewCell: ShadowCornerCollectionViewCell {
    
    let centerHexBtn = HexagonButton(fontSize: 20)
    let upperHexBtn = HexagonButton(fontSize: 20)
    let lowerHexBtn = HexagonButton(fontSize: 20)
    let rightUpHexBtn = HexagonButton(fontSize: 20)
    let rightLowHexBtn = HexagonButton(fontSize: 20)
    let leftUpHexBtn = HexagonButton(fontSize: 20)
    let leftLowHexBtn = HexagonButton(fontSize: 20)
    
    @IBOutlet weak var hexagonsView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var width: CGFloat = 0
    var buttonWidth: CGFloat = 0
    
    var buttonHeight: CGFloat = 0
    var centerButtonsXPosition: CGFloat = 0
    var leftButtonsXPosition: CGFloat = 0
    var rightButtonsXPosition: CGFloat = 0
    
    var distanceRightToCenterBtns: CGFloat = 0
    var distanceLeftToCenterBtns: CGFloat = 0
    
    var padding: CGFloat = 5
    
    var hexButtons = [HexagonButton]()
    
    var hexagonsViewWidthPart1: CGFloat = 0
    var hexagonsViewWidthPart2: CGFloat = 0
    
    var buttonWidth1: CGFloat = 0
    var buttonWidth2: CGFloat = 0
    
    
    var contentSize = CGSize(width: 0, height: 0) {
        didSet {
            buttonsSetup()
        }
    }
    
    var letters = [String]() {
        didSet {
            changeTitleNames()
        }
    }
    var guessedWords = [String]()
    var correctWords = [String]()
    var isDaily: Bool? = nil
    
    var dateAdded = Date()
    
    let userCalendar = Calendar.current
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hexButtons.append(contentsOf: [centerHexBtn, upperHexBtn, lowerHexBtn, leftUpHexBtn, leftLowHexBtn, rightUpHexBtn, rightLowHexBtn])
        
        hexagonsView.clipsToBounds = true
        
        adjustButtonFontSize()
        
        for hexButton in hexButtons {
            hexButton.translatesAutoresizingMaskIntoConstraints = false
            hexButton.isEnabled = false
            
            if hexButton != centerHexBtn {
                hexButton.color = UIColor.init(named: "Gray")
            }
            self.hexagonsView.addSubview(hexButton)
        }
        
        self.hexagonsView.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(named: "Light White")!
        
        layoutIfNeeded()
        
//        buttonsSetup()
        
        labelSetup()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        adjustButtonFontSize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustButtonFontSize()
    }
    
    func changeTitleNames() {
        
        var titleLetters = letters
        
        centerHexBtn.setTitle(titleLetters[0], for: .normal)
        titleLetters.remove(at: 0)
        
        for i in 1...hexButtons.count - 1 {
            hexButtons[i].setTitle(titleLetters[i - 1], for: .normal)
        }
        
    }
    
    func labelSetup() {
        
        textLabel.baselineAdjustment = .alignCenters
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.1
        textLabel.font = UIFont(name: "Helvetica Bold", size: textLabel.font.pointSize)
        
        languageLabel.adjustsFontSizeToFitWidth = true
        languageLabel.minimumScaleFactor = 0.1
        languageLabel.font = UIFont(name: "Helvetica Bold", size: textLabel.font.pointSize)
        languageLabel.baselineAdjustment = .alignCenters
    }
    
    
    
    func buttonsSetup() {
        
        layoutIfNeeded()
        setNeedsLayout()
                
        padding = self.hexagonsView.frame.width / 20
        
//        width = self.contentView.frame.width
        buttonWidth1 = self.hexagonsView.frame.width * 0.8
        buttonWidth2 = ((tan(.pi / 3) * (padding / 2))) * 2
        buttonWidth = (buttonWidth1 - buttonWidth2) * (2 / 5)
        buttonHeight = abs(tan(.pi / 3) * buttonWidth / 4 * 2) //actual height of button
        centerButtonsXPosition = width / 2 - buttonWidth / 2
        rightButtonsXPosition = centerButtonsXPosition + buttonWidth / 4 * 3
                
        distanceRightToCenterBtns = -(buttonWidth / 4) + ((tan(.pi / 3) * (padding / 2)))
        distanceLeftToCenterBtns = -distanceRightToCenterBtns
        
        
        let constraints = [
            
            centerHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            centerHexBtn.centerYAnchor.constraint(equalTo: hexagonsView.centerYAnchor),
            centerHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            centerHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            upperHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            upperHexBtn.bottomAnchor.constraint(equalTo: centerHexBtn.topAnchor, constant: buttonWidth - buttonHeight - padding),
            upperHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            upperHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            lowerHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            lowerHexBtn.topAnchor.constraint(equalTo: centerHexBtn.bottomAnchor, constant: -(buttonWidth - buttonHeight) + padding),
            lowerHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            lowerHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            rightUpHexBtn.leftAnchor.constraint(equalTo: upperHexBtn.rightAnchor, constant: distanceRightToCenterBtns),
            rightUpHexBtn.topAnchor.constraint(equalTo: upperHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            rightUpHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            rightUpHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            rightLowHexBtn.leftAnchor.constraint(equalTo: centerHexBtn.rightAnchor, constant: distanceRightToCenterBtns),
            rightLowHexBtn.topAnchor.constraint(equalTo: centerHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            rightLowHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            rightLowHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            leftUpHexBtn.rightAnchor.constraint(equalTo: upperHexBtn.leftAnchor, constant: distanceLeftToCenterBtns),
            leftUpHexBtn.topAnchor.constraint(equalTo: upperHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            leftUpHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            leftUpHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
            leftLowHexBtn.rightAnchor.constraint(equalTo: centerHexBtn.leftAnchor, constant: distanceLeftToCenterBtns),
            leftLowHexBtn.topAnchor.constraint(equalTo: centerHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            leftLowHexBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            leftLowHexBtn.heightAnchor.constraint(equalToConstant: buttonWidth),
            
        ]
        
        let moreConstraints: [NSLayoutConstraint] = [
//            hexagonsView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            hexagonsView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
//            hexagonsView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            hexagonsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -30),
//            hexagonsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            hexagonsView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(moreConstraints)
        NSLayoutConstraint.activate(constraints)
        
        adjustButtonFontSize()
    }
    
    func adjustButtonFontSize() {
        
        for button in hexButtons {
            let width = button.frame.width
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: width / 2.5, weight: .bold)
        }
    }
    
    
}
