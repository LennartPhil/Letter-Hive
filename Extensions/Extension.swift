//
//  Extensions.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 03.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
}



extension UIButton {
    
    func animateSmall() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.05, initialSpringVelocity: 1, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func animateReturn() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.05, initialSpringVelocity: 1, options: [], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}

extension UIViewController {
    
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 2), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}




// returns the difference between two arrays
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}



// removes duplicates in array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
