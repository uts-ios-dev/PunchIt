//
//  TextFieldExtensions.swift
//  Punch It
//
//  Created by Phan Thế Trung on 1/6/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    func shake(){
        let keyName = "position"
        let animation = CABasicAnimation(keyPath: keyName)
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 10.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 10.0, y: self.center.y)
        layer.add(animation, forKey: keyName)
    }
}
