//
//  ImageCollectionViewCell.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 19.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: ShadowCornerCollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
//    let padding: CGFloat = 30
    
//    let cellImageView = UIImageView()
        
//    var maxWidthConstraint = NSLayoutConstraint()
//    var maxHeightConstraint = NSLayoutConstraint()
    
//    var maxWidth: CGFloat? = nil {
//        didSet {
//            guard let maxWidth = maxWidth else {
//                return
//            }
//
//            maxWidthConstraint.isActive = true
//            maxWidthConstraint.constant = maxWidth - (2 * padding)
//
//            maxHeightConstraint.isActive = true
//            maxHeightConstraint.constant = maxWidth - (2 * padding)
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
//        maxWidthConstraint = NSLayoutConstraint(item: cellImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
//        maxHeightConstraint = NSLayoutConstraint(item: cellImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
//
        NSLayoutConstraint.activate([

            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
        
        contentView.backgroundColor = UIColor(named: "Light White")
        
//        cellImageView.translatesAutoresizingMaskIntoConstraints = false
//        cellImageView.backgroundColor = .clear
//        cellImageView.contentMode = .scaleAspectFit
//        contentView.addSubview(cellImageView)
//
//        NSLayoutConstraint.activate([
//
//            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
//            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
//            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
//            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
//
//        ])
    }
    
}
