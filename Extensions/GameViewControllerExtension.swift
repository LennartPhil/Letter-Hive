//
//  GameViewControllerExtension.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 05.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    
    func buttonsSetup() {
        
        width = hexagonsView.frame.width
        buttonWidth = centerHexBtn.frame.width
        buttonHeight = abs(tan(.pi / 3) * buttonWidth / 4 * 2) //actual height of button
        centerButtonsXPosition = width / 2 - buttonWidth / 2
        rightButtonsXPosition = centerButtonsXPosition + buttonWidth / 4 * 3
                
        distanceRightToCenterBtns = -(buttonWidth / 4) + ((tan(.pi / 3) * (padding / 2)))
        distanceLeftToCenterBtns = -distanceRightToCenterBtns
        
        hexagonsViewWidthPart1 = buttonWidth * 2 + buttonWidth / 2
        hexagonsViewWidthPart2 = ((tan(.pi / 3) * (padding / 2))) * 2
        
        let constraints = [
            
            centerHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            centerHexBtn.centerYAnchor.constraint(equalTo: hexagonsView.centerYAnchor),
            
            upperHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            upperHexBtn.bottomAnchor.constraint(equalTo: centerHexBtn.topAnchor, constant: buttonWidth - buttonHeight - padding),
            
            lowerHexBtn.centerXAnchor.constraint(equalTo: hexagonsView.centerXAnchor),
            lowerHexBtn.topAnchor.constraint(equalTo: centerHexBtn.bottomAnchor, constant: -(buttonWidth - buttonHeight) + padding),
            
            rightUpHexBtn.leftAnchor.constraint(equalTo: upperHexBtn.rightAnchor, constant: distanceRightToCenterBtns),
            rightUpHexBtn.topAnchor.constraint(equalTo: upperHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            
            rightLowHexBtn.leftAnchor.constraint(equalTo: centerHexBtn.rightAnchor, constant: distanceRightToCenterBtns),
            rightLowHexBtn.topAnchor.constraint(equalTo: centerHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            
            leftUpHexBtn.rightAnchor.constraint(equalTo: upperHexBtn.leftAnchor, constant: distanceLeftToCenterBtns),
            leftUpHexBtn.topAnchor.constraint(equalTo: upperHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            
            leftLowHexBtn.rightAnchor.constraint(equalTo: centerHexBtn.leftAnchor, constant: distanceLeftToCenterBtns),
            leftLowHexBtn.topAnchor.constraint(equalTo: centerHexBtn.centerYAnchor, constant: -((buttonWidth - buttonHeight) / 2) + (padding / 2)),
            
            hexagonsView.heightAnchor.constraint(equalToConstant: buttonHeight * 3 + padding * 2),
            hexagonsView.widthAnchor.constraint(equalToConstant: hexagonsViewWidthPart1 + hexagonsViewWidthPart2)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
}
