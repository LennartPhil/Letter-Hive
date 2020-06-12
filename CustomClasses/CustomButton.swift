//
//  CustomButton.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 05.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.cornerRadius = self.frame.size.height / 2
//        self.layer.borderColor = UIColor.darkGray.cgColor
//        self.layer.borderWidth = 3
//        
//        setTitleColor(.darkGray, for: .normal)
//
        setupActions()
    }
    
    func setupActions() {
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp), for: [.touchCancel, .touchDragExit, .touchUpInside, .touchUpInside])
        self.addTarget(self, action: #selector(lightVibration), for: .touchUpInside)
    }
    
    @objc func touchUp() {
        self.animateReturn()
    }
    
    @objc func touchDown() {
        self.animateSmall()
    }
    
    @objc func lightVibration() {
        vibration.lightVibration()
    }
}
