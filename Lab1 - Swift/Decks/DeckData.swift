//
//  Deck.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-15.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


class DeckData {
    
    static let data = DeckData()
    
    let userDefaults = UserDefaults.standard
    var decks:[Deck] = []
    
    func saveDecks() {
        var decksData:[[Data]] = []
        
        for deck in decks {
            let deckUUID = deck.deckUUID
            let deckType = deck.deckType
            let deckClass = deck.deckClass
            let deckName = deck.deckName
            var deckCards:[[Data]] = []
            
            for card in deck.deckCards {
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
                
                deckCards.append(cardData)
            }
            
            let uuidData = try? NSKeyedArchiver.archivedData(withRootObject: deckUUID, requiringSecureCoding: false)
            let typeData = try? NSKeyedArchiver.archivedData(withRootObject: deckType, requiringSecureCoding: false)
            let classData = try? NSKeyedArchiver.archivedData(withRootObject: deckClass, requiringSecureCoding: false)
            let nameData = try? NSKeyedArchiver.archivedData(withRootObject: deckName, requiringSecureCoding: false)
            let cardsData = try? NSKeyedArchiver.archivedData(withRootObject: deckCards, requiringSecureCoding: false)
            
            let deckData:[Data] = [uuidData! as Data, typeData! as Data, classData! as Data, nameData! as Data, cardsData! as Data]
            
            decksData.append(deckData)
            print("\(deck.deckName) saved")
        }
        
        userDefaults.set(decksData, forKey: SaveKeys.allDecksKey)
    }
    
    func loadDecks() {
        decks.removeAll()
        
        if let decksData:[[Data]] = userDefaults.object(forKey: SaveKeys.allDecksKey) as? [[Data]] {
            for deckData in decksData {
                let uuidData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(deckData[0] as Data) as! String
                let typeData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(deckData[1] as Data) as! String
                let classData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(deckData[2] as Data) as! String
                let nameData:String = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(deckData[3] as Data) as! String
                let cardsData:[[Data]] = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(deckData[4] as Data) as! [[Data]]
                
                var cards:[Card] = []
                for cardData in cardsData {
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
                    
                    cards.append(card)
                }
                
                let deck:Deck = Deck(deckUUID:uuidData, deckType: typeData, deckClass: classData, deckName: nameData, deckCards: cards)
                DeckData.data.decks.append(deck)
                print("Deck loaded: \(deck.deckName)")
            }
        } else {
            print("No deck data found")
        }
    }
}
