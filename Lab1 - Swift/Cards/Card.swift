//
//  Card.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-13.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


class Card {
    var cardId:String
    var dbfId:String
    var name:String
    var cardSet:String
    var type:String
    var rarity:String
    var cost:Int
    var playerClass:String
    var img:String
    
    init (json:[String:Any]) {
        let cardId = json["cardId"] ?? "Missing cardId"
        let dbfId = json["dbfId"] ?? "Missing dbfId"
        let name = json["name"] ?? "Missing name"
        let cardSet = json["cardSet"] ?? "Missing cardSet"
        let type = json["type"] ?? "Missing type"
        let rarity = json["rarity"] ?? "Missing rarity"
        let cost = json["cost"] ?? -1
        let playerClass = json["playerClass"] ?? "Missing playerClass"
        let img = json["img"] ?? "Missing img"
        
        self.cardId = cardId as! String
        self.dbfId = dbfId as! String
        self.name = name as! String
        self.cardSet = cardSet as! String
        self.type = type as! String
        self.rarity = rarity as! String
        self.cost = cost as! Int
        self.playerClass = playerClass as! String
        self.img = img as! String
    }
    
    init(cardId:String, dbfId:String, name:String, cardSet:String, type:String, rarity:String, cost:Int, playerClass:String, img:String) {
        self.cardId = cardId
        self.dbfId = dbfId
        self.name = name
        self.cardSet = cardSet
        self.type = type
        self.rarity = rarity
        self.cost = cost
        self.playerClass = playerClass
        self.img = img
    }
    
    init(coder aDecoder: NSCoder) {
        self.cardId = aDecoder.decodeObject(forKey: "cardId") as! String
        self.dbfId = aDecoder.decodeObject(forKey: "dbfId") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.cardSet = aDecoder.decodeObject(forKey: "cardSet") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.rarity = aDecoder.decodeObject(forKey: "rarity") as! String
        self.cost = aDecoder.decodeObject(forKey: "cost") as! Int
        self.playerClass = aDecoder.decodeObject(forKey: "playerClass") as! String
        self.img = aDecoder.decodeObject(forKey: "img") as! String
    }
    
    func initWithCoder(aDecoder: NSCoder) -> Card {
        self.cardId = aDecoder.decodeObject(forKey: "cardId") as! String
        self.dbfId = aDecoder.decodeObject(forKey: "dbfId") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.cardSet = aDecoder.decodeObject(forKey: "cardSet") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.rarity = aDecoder.decodeObject(forKey: "rarity") as! String
        self.cost = aDecoder.decodeObject(forKey: "cost") as! Int
        self.playerClass = aDecoder.decodeObject(forKey: "playerClass") as! String
        self.img = aDecoder.decodeObject(forKey: "img") as! String
        return self
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encode(self.cardId, forKey: "cardId")
        aCoder.encode(self.dbfId, forKey: "dbfId")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.cardSet, forKey: "cardSet")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.rarity, forKey: "rarity")
        aCoder.encode(self.cost, forKey: "cost")
        aCoder.encode(self.playerClass, forKey: "playerClass")
        aCoder.encode(self.img, forKey: "img")
    }
    
}
