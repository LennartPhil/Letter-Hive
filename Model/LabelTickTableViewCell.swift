//
//  LabelTickTableViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 18.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class LabelTickTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var tickImage: UIImageView!
    
    var tickHidden: Bool = true {
        didSet {
            if tickHidden {
                tickImage.isHidden = true
            } else {
                tickImage.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
