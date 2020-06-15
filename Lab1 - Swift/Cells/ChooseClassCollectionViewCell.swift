//
//  ChooseClassCollectionViewCell.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-24.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class ChooseClassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewClassPortrait: UIImageView!
    @IBOutlet weak var imageViewClassIcon: UIImageView!
    @IBOutlet weak var labelClassName: UILabel!
    
    
    func configure(with portrait:UIImage, icon:UIImage, name:String) {
        self.imageViewClassPortrait.image = portrait
        self.imageViewClassIcon.image = icon
        self.labelClassName.text = name
        
        setupLabel()
        
//        self.alpha = 0.5
    }
    
    func setupLabel() {
        self.labelClassName.font = self.labelClassName.font.bold
        self.labelClassName.shadowColor   = UIColor.black
        self.labelClassName.shadowOffset  = CGSize(width: 2, height: 2)
    }
    
}
