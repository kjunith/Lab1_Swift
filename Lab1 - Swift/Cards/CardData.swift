//
//  DataHandler.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-16.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


class CardData {
    
    static let data = CardData()
    
    let userDefaults = UserDefaults.standard
    
    func saveCards() {
        
        var allCardsData:[[Data]] = []
        var standardCardsData:[[Data]] = []
        
            for card in CardsAPI.collection.allCards {
                let cardId = try? NSKeyedArchiver.archivedData(withRootObject: card.cardId, requiringSecureCoding: false)
                let dbfId = try? NSKeyedArchiver.archivedData(withRootObject: card.dbfId, requiringSecureCoding: false)
                let name = try? NSKeyedArchiver.archivedData(withRootObject: card.name, requiringSecureCoding: false)
                let cardSet = try? NSKeyedArchiver.archivedData(withRootObject: card.cardSet, requiringSecureCoding: false)
                let type = try? NSKeyedArchiver.archivedData(withRootObject: card.type, requiringSecureCoding: false)
                let rarity = try? NSKeyedArchiver.archivedData(withRootObject: card.rarity, requiringSecureCoding: false)
                let cost = try? NSKeyedArchiver.archivedData(withRootObject: card.cost, requiringSecureCoding: false)
                let playerClass = try? NSKeyedArchiver.archivedData(withRootObject: card.playerClass, requiringSecureCoding: false)
                let img = try? NSKeyedArchiver.archivedData(withRootObject: card.img, requiringSecureCoding: false)
                
                let cardData:[Data] = [
                    cardId! as Data,
                    dbfId! as Data,
                    name! as Data,
                    cardSet! as Data,
                    type! as Data,
                    rarity! as Data,
                    cost! as Data,
                    playerClass! as Data,
                    img! as Data
                ]
                
                allCardsData.append(cardData)
            }
        
        for card in CardsAPI.collection.standardCards {
            let cardId = try? NSKeyedArchiver.archivedData(withRootObject: card.cardId, requiringSecureCoding: false)
            let dbfId = try? NSKeyedArchiver.archivedData(withRootObject: card.dbfId, requiringSecureCoding: false)
            let name = try? NSKeyedArchiver.archivedData(withRootObject: card.name, requiringSecureCoding: false)
            let cardSet = try? NSKeyedArchiver.archivedData(withRootObject: card.cardSet, requiringSecureCoding: false)
            let type = try? NSKeyedArchiver.archivedData(withRootObject: card.type, requiringSecureCoding: false)
            let rarity = try? NSKeyedArchiver.archivedData(withRootObject: card.rarity, requiringSecureCoding: false)
            let cost = try? NSKeyedArchiver.archivedData(withRootObject: card.cost, requiringSecureCoding: false)
            let playerClass = try? NSKeyedArchiver.archivedData(withRootObject: card.playerClass, requiringSecureCoding: false)
            let img = try? NSKeyedArchiver.archivedData(withRootObject: card.img, requiringSecureCoding: false)
            
            let cardData:[Data] = [
                cardId! as Data,
                dbfId! as Data,
                name! as Data,
                cardSet! as Data,
                type! as Data,
                rarity! as Data,
                cost! as Data,
                playerClass! as Data,
                img! as Data
            ]
            
            standardCardsData.append(cardData)
        }
        
        userDefaults.set(allCardsData, forKey: SaveKeys.allCardsKey)
        print("All card data saved")
        userDefaults.set(standardCardsData, forKey: SaveKeys.standardCardsKey)
        print("Standard card data saved")
    }
    
    func loadCards() -> Bool {
        var allCardsOk:Bool
        var standardCardsOk:Bool
        
        if let allCardsData:[[Data]] = userDefaults.object(forKey: SaveKeys.allCardsKey) as? [[Data]] {
            for cardData in allCardsData {
                let cardId:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[0] as Data) as! String
                let dbfId:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[1] as Data) as! String
                let name:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[2] as Data) as! String
                let cardSet:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[3] as Data) as! String
                let type:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[4] as Data) as! String
                let rarity:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[5] as Data) as! String
                let cost:Int = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[6] as Data) as! Int
                let playerClass:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[7] as Data) as! String
                let img:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[8] as Data) as! String
                
                let card = Card(cardId: cardId, dbfId: dbfId, name: name, cardSet: cardSet, type: type, rarity: rarity, cost: cost, playerClass: playerClass, img: img)
                
                CardsAPI.collection.allCards.append(card)
            }
            
            allCardsOk = true
            print("All card data loaded")
        } else {
            allCardsOk = false
            print("No card data found")
        }
        
        if let standardCardsData:[[Data]] = userDefaults.object(forKey: SaveKeys.standardCardsKey) as? [[Data]] {
            for cardData in standardCardsData {
                let cardId:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[0] as Data) as! String
                let dbfId:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[1] as Data) as! String
                let name:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[2] as Data) as! String
                let cardSet:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[3] as Data) as! String
                let type:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[4] as Data) as! String
                let rarity:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[5] as Data) as! String
                let cost:Int = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[6] as Data) as! Int
                let playerClass:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[7] as Data) as! String
                let img:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cardData[8] as Data) as! String
                
                let card = Card(cardId: cardId, dbfId: dbfId, name: name, cardSet: cardSet, type: type, rarity: rarity, cost: cost, playerClass: playerClass, img: img)
                
                CardsAPI.collection.standardCards.append(card)
            }
            
            standardCardsOk = true
            print("Standard card data loaded")
        } else {
            standardCardsOk = false
            print("No standard card data found")
        }
        
        return (allCardsOk && standardCardsOk)
    }
    
}
