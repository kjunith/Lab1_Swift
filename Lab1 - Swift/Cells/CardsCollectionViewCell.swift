//
//  AllCardsCollectionViewCell.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-21.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit


class CardsCollectionViewCell: UICollectionViewCell {
    
    var card:Card?
    var cardsDelegate:CardsDelegate?
    var cardCount = Int()
    
    @IBOutlet weak var imageViewCardArt: UIImageView!
    @IBOutlet weak var labelCardName: UILabel!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var viewRemove: UIView!
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var labelCardCount: UILabel!
    
    public func configure(with card:Card) {
        let img:String = card.img
        let name:String = card.name
        self.card = card
        
        imageViewCardArt?.sd_setImage(with: URL(string: img), completed: nil)
        labelCardName?.text = name
        
        labelCardName?.font = labelCardName?.font.bold
        labelCardName?.shadowOffset = CGSize(width: 1, height: 1)
        labelCardName?.shadowColor = UIColor.black
        
        self.cardCount = 0
        for deckCard in DeckTemplate.deckCards {
            if deckCard.cardId == card.cardId {
                self.cardCount += 1
            }
        }
        updateButtons()
        
        labelCardCount.text = "\(String(describing: self.cardCount))"
        
        setupLabels()
    }
    
    func setupLabels() {
        buttonAdd.titleLabel?.font = buttonAdd.titleLabel?.font.bold
        buttonAdd.titleLabel?.layer.shadowOffset = CGSize(width: 2, height: 2)
        buttonAdd.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        buttonAdd.titleLabel?.layer.shadowRadius  = 4
        buttonAdd.titleLabel?.layer.shadowOpacity = 1
        
        buttonRemove.titleLabel?.font = buttonRemove.titleLabel?.font.bold
        buttonRemove.titleLabel?.layer.shadowOffset = CGSize(width: 2, height: 2)
        buttonRemove.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        buttonRemove.titleLabel?.layer.shadowRadius  = 4
        buttonRemove.titleLabel?.layer.shadowOpacity = 1
        
        labelCardCount.font = labelCardCount.font.bold
        labelCardCount.shadowOffset = CGSize(width: 2, height: 2)
        labelCardCount.shadowColor = UIColor.black
    }
    
    @IBAction func onAddPressed(_ sender: Any) {
        if (cardsDelegate!.addCardToDeck(card: self.card!)) {
            self.cardCount += 1
            self.labelCardCount.text = "\(String(describing: cardCount))"
        }
        
        updateButtons()
        print("Add card pressed")
    }
    
    @IBAction func onRemovePressed(_ sender: Any) {
        if (cardsDelegate!.removeCardFromDeck(card: self.card!)) {
            self.cardCount -= 1
            self.labelCardCount.text = "\(cardCount)"
        }
        
        updateButtons()
        print("Remove card pressed")
    }
    
    func updateButtons() {
        switch self.cardCount {
        case 0:
            self.viewAdd.alpha = 1
            self.viewRemove.alpha = 0
        case 1:
            self.viewAdd.alpha = 1
            self.viewRemove.alpha = 1
        case 2:
            self.viewAdd.alpha = 0
            self.viewRemove.alpha = 1
        default:
            self.viewAdd.alpha = 1
            self.viewRemove.alpha = 0
        }
    }
}
