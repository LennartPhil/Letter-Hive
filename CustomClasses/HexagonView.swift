//
//  HexagonView.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 09.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

class HexagonView: UIView {
    
    var color: UIColor? = UIColor(red: 247/255, green: 204/255, blue: 47/255, alpha: 1.0)
    var shapePath = UIBezierPath()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
            
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let radiusOuterCircle: CGFloat = self.frame.width / 2
        let centerXY = self.frame.width / 2
        let initialPoint = CGPoint(x: 0, y: centerXY)
        
        shapePath.move(to: initialPoint)
        
        let secondPoint = CGPoint(x: radiusOuterCircle / 2, y: abs(tan(CGFloat.pi / 3) * (radiusOuterCircle / 2)) + centerXY)
        let thirdPoint = CGPoint(x: radiusOuterCircle / 2 * 3, y: secondPoint.y)
        let fourthPoint = CGPoint(x: radiusOuterCircle * 2, y: centerXY)
        let fifthPoint = CGPoint(x: thirdPoint.x, y: centerXY - abs(tan(CGFloat.pi / 3) * (radiusOuterCircle / 2)))
        let sixthPoint = CGPoint(x: centerXY / 2, y: fifthPoint.y)
        
        shapePath.addLine(to: secondPoint)
        shapePath.addLine(to: thirdPoint)
        shapePath.addLine(to: fourthPoint)
        shapePath.addLine(to: fifthPoint)
        shapePath.addLine(to: sixthPoint)
        shapePath.close()
        
        color?.set()
        
        //        UIColor(red: 247/255, green: 204/255, blue: 47/255, alpha: 1.0).set()
        shapePath.fill()
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
