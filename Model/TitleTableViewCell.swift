//
//  HeaderTableViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 04.05.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var delegate: DismissViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        print("I got fuching pressed, this is the button talking")
        delegate?.dismissViewController()
        
    }
}

protocol DismissViewControllerDelegate {
    func dismissViewController()
}
