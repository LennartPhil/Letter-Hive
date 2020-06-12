//
//  HexagonButton.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 02.04.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit

@IBDesignable
class HexagonButton: UIButton {
    
    @IBInspectable var color: UIColor? = UIColor(red: 247/255, green: 204/255, blue: 47/255, alpha: 1.0)
    
    var titleFontSize: CGFloat = 30
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(fontSize: CGFloat = 30) {
        super.init(frame: .zero)
        self.titleFontSize = fontSize
    }
    
    func setup() {
        
        self.clipsToBounds = true
        
//        self.setTitleColor(.black, for: .normal)
//        self.titleLabel!.font = UIFont.init(name: "Helvetica Bold", size: 30)
        
        self.backgroundColor = .clear
        
    }
    
    var shapePath = UIBezierPath()
    
    //Stackoverflow
    override func awakeFromNib() {
        addTarget(self, action: #selector(touchDown(button:event:)), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchCancel, .touchDragExit, .touchUpInside, .touchUpInside])
//        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    //Stackoverflow
     
    override func draw(_ rect: CGRect) {
        
        self.setTitleColor(.black, for: .normal)
        self.titleLabel!.font = UIFont.init(name: "Helvetica Bold", size: titleFontSize)
        
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
    
    
    @objc func touchDown(button: HexagonButton, event: UIEvent) {
        if let touch = event.touches(for: button)?.first {
            let location = touch.location(in: button)

            if shapePath.contains(location) == false {
                button.cancelTracking(with: nil)
            } else {
                
//                UIView.animate(withDuration: 0.1) {
//                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//                }
                self.animateSmall()
            }
        }
    }
    
    @objc func touchUp() {
//        UIView.animate(withDuration: 0.1) {
//            self.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
        self.animateReturn()
    }
    
    @objc func touchUpInside() {
        vibration.lightVibration()
    }
}
