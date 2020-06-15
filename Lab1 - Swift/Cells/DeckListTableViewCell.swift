//
//  DecklistTableViewCell.swift
//  Swift - Lab1
//
//  Created by Jimmie Määttä on 2019-03-23.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import SDWebImage

class DeckListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewDeckType: UIImageView!
    @IBOutlet weak var imageViewClassIcon: UIImageView!
    @IBOutlet weak var labelDeckName: UILabel!
    @IBOutlet weak var labelCardCount: UILabel!
    
    func configure(with deck:Deck) {
        let deckType:String = deck.deckType
        let deckClass:String = deck.deckClass
        let deckName:String = deck.deckName
        let cardCount:String = "\(deck.deckCards.count)/30"
        
        imageViewDeckType.image = UIImage(named: "\(deckType)")
        imageViewClassIcon.image = UIImage(named: "\(deckClass)HeroPower")
        labelDeckName.text = deckName
        labelCardCount.text = cardCount
        
        setupLabels()
    }
    
    private func setupLabels() {
        labelDeckName.textColor = UIColor(named: "colorYellow")
        labelDeckName.font = labelDeckName.font.bold
        
        labelCardCount.textColor = UIColor.white
        labelCardCount.font = labelCardCount.font.bold
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
