//
//  CustomTextField.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 25.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
