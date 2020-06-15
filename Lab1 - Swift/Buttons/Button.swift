//
//  Button.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-24.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        
        setupTitle()
        setTitleShadow()
        setImages()
        setButtonShadow()
        setConstraints()
    }
    
    private func setupTitle() {
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.gray, for: .highlighted)
        titleLabel?.font = UIFont(name: "Hoefler Text", size: 20)
        titleLabel?.font = titleLabel?.font.bold
    }
    
    private func setTitleShadow() {
        titleLabel?.layer.shadowColor   = UIColor.black.cgColor
        titleLabel?.layer.shadowOffset  = CGSize(width: 1, height: 1)
        titleLabel?.layer.shadowRadius  = 4
        titleLabel?.layer.shadowOpacity = 1
    }
    
    private func setButtonShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 10)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 1
    }
    
    private func setImages() {
        setBackgroundImage(UIImage(named: "ButtonNormal"), for: .normal)
        setBackgroundImage(UIImage(named: "ButtonPressed"), for: .selected)
    }
    
    private func setConstraints() {
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        widthAnchor.constraint(equalToConstant: 172).isActive = true
    }
}
