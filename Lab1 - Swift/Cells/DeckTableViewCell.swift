//
//  DeckTableViewCell.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-27.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {
    
    var card:Card?
    var cardsDelegate:CardsDelegate?
    
    @IBOutlet weak var imageViewCardArt: UIImageView!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelCardName: UILabel!
    
    public func configure(with card:Card) {
        let img:String = card.img
        let name:String = card.name
        let cost:String = "\(card.cost)"
        self.card = card
        
        imageViewCardArt?.sd_setImage(with: URL(string: img), completed: nil)
        labelCardName?.text = name
        labelCost?.text = cost
        
        labelCardName?.font = labelCardName?.font.bold
        labelCardName?.shadowOffset = CGSize(width: 1, height: 1)
        labelCardName?.shadowColor = UIColor.black
        
        labelCost?.font = labelCardName?.font.bold
        labelCost?.shadowOffset = CGSize(width: 1, height: 1)
        labelCost?.shadowColor = UIColor.black
    }
}
