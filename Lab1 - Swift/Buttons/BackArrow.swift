//
//  BackArrow.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-24.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class BackArrow: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        titleLabel?.font = titleLabel!.font.bold
        
        setImages()
        setButtonShadow()
        setConstraints()
    }
    
    private func setButtonShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 10)
        layer.shadowRadius  = 8
        layer.shadowOpacity = 1
    }
    
    private func setImages() {
        setBackgroundImage(UIImage(named: "ArrowNormal"), for: .normal)
        setBackgroundImage(UIImage(named: "ArrowPressed"), for: .selected)
    }
    
    private func setConstraints() {
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        widthAnchor.constraint(equalToConstant: 113).isActive = true
    }
}
