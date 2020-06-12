//
//  TextImageTableViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 04.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class TextImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    var tickHidden: Bool = true {
        didSet {
            if tickHidden {
                tickImageView.isHidden = true
            } else {
                tickImageView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
