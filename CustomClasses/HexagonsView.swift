//
//  HexagonsView.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 03.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class HexagonsView: UIView {
    
    let centerBtn = HexagonButton()
    let upperBtn = HexagonButton()
    let lowerBtn = HexagonButton()
    let leftUpBtn = HexagonButton()
    let leftLowBtn = HexagonButton()
    let rightUpBtn = HexagonButton()
    let rightLowBtn = HexagonButton()
    
    var buttons = [HexagonButton]()
    
    var width: CGFloat = 0
    var buttonWidth: CGFloat = 100
    
    var buttonHeight: CGFloat = 0
    var centerButtonsXPosition: CGFloat = 0
    var leftButtonsXPosition: CGFloat = 0
    var rightButtonsXPosition: CGFloat = 0
    
    @IBInspectable var padding: CGFloat = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttons.append(contentsOf: [centerBtn, upperBtn, lowerBtn, leftUpBtn, leftLowBtn, rightUpBtn, rightLowBtn])
        
        for button in buttons {
            addSubview(button)
            button.frame.size = CGSize(width: buttonWidth, height: buttonWidth)
        }
        
        width = self.frame.width
        buttonHeight = abs(tan(.pi / 3) * buttonWidth / 4 * 2)
        centerButtonsXPosition = width / 2 - buttonWidth / 2
        rightButtonsXPosition = centerButtonsXPosition + buttonWidth / 4 * 3
        
        upperBtn.frame.origin = CGPoint(x: centerButtonsXPosition, y: 0)
        centerBtn.frame.origin = CGPoint(x: centerButtonsXPosition, y: buttonHeight + padding)
        lowerBtn.frame.origin = CGPoint(x: centerButtonsXPosition, y: 2 * buttonHeight + 2 * padding)
        rightUpBtn.frame.origin = CGPoint(x: rightButtonsXPosition, y: buttonWidth - buttonHeight)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    
    
    

}
