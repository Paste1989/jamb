//
//  RoundButton.swift
//  Jamb
//
//  Created by Saša Brezovac on 24.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var roundButton: Bool = false {
        didSet{
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = frame.height / 2
        }
    }
}
