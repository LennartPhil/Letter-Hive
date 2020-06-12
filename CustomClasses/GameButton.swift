//
//  GameButton.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 10.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class GameButton: CustomButton {

    override func awakeFromNib() {
        
        setupActions()
        
        layer.cornerRadius = frame.height / 2
        
        backgroundColor = UIColor(named: "Yellow")?.withAlphaComponent(0.7)
        
        titleLabel?.font = UIFont(name: "Helvetica Bold", size: self.titleLabel!.font.pointSize)
        setTitleColor(.white, for: .normal)
    }
}
