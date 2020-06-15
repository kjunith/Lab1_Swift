//
//  Deck.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-16.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


struct DeckTemplate {
    
    static var deckUUID:String = ""
    static var deckType:String = ""
    static var deckClass:String = ""
    static var deckName:String = ""
    static var deckCards:[Card] = []
    
    static var isFull:Bool {
        let maxDeckSize:Int = 30
        if self.deckCards.count == maxDeckSize {
            return true
        } else {
            return false
        }
    }
}

class Deck {
    var deckUUID:String
    var deckType:String
    var deckClass:String
    var deckName:String
    var deckCards:[Card]
    
    init(deckUUID:String, deckType:String, deckClass:String, deckName:String, deckCards:[Card]) {
        self.deckUUID = deckUUID
        self.deckType = deckType
        self.deckClass = deckClass
        self.deckName = deckName
        self.deckCards = deckCards
    }
    
    init(coder aDecoder: NSCoder) {
        self.deckUUID = aDecoder.decodeObject(forKey: "deckUUID") as! String
        self.deckType = aDecoder.decodeObject(forKey: "deckType") as! String
        self.deckClass = aDecoder.decodeObject(forKey: "deckClass") as! String
        self.deckName = aDecoder.decodeObject(forKey: "deckName") as! String
        self.deckCards = aDecoder.decodeObject(forKey: "deckCards") as! [Card]
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Deck {
        self.deckUUID = aDecoder.decodeObject(forKey: "deckUUID") as! String
        self.deckType = aDecoder.decodeObject(forKey: "deckType") as! String
        self.deckClass = aDecoder.decodeObject(forKey: "deckClass") as! String
        self.deckName = aDecoder.decodeObject(forKey: "deckName") as! String
        self.deckCards = aDecoder.decodeObject(forKey: "deckCards") as! [Card]
        return self
    }
    
    func encdoeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.deckUUID, forKey: "deckUUID")
        aCoder.encode(self.deckType, forKey: "deckType")
        aCoder.encode(self.deckClass, forKey: "deckClass")
        aCoder.encode(self.deckName, forKey: "deckName")
        aCoder.encode(self.deckCards, forKey: "deckCards")
    }
    
}
