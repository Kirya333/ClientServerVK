//
//  BackImageView.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 13.07.2021.
//

import UIKit

class BackImageView: UIView {
    
    @IBInspectable var shadowRadius: CGFloat = 3
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.7
    
    func setShadow() {
        self.layer.cornerRadius = 20
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
    }
}
