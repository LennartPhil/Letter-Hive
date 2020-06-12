//
//  ShadowCornerCollectionViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 21.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class ShadowCornerCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
}
