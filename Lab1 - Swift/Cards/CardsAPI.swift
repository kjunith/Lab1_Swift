//
//  CardSets.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-15.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation

class CardsAPI {
    
    static let collection = CardsAPI()
    
    let baseUrl = "https://omgvamp-hearthstone-v1.p.rapidapi.com/cards"
    
    var setNames:[String] = []
    var allCards:[Card] = []
    var standardCards:[Card] = []
    let standardSets = ["Basic", "Classic", "Kobolds and Catacombs", "The Witchwood", "The Boomsday Project", "Rastakhan's Rumble"]
    
    var setCount:Int = 0
    
    func fetchData() {
        print("* Started fetching: Set Names")
        
        var setArray:[String] = []
        
        let url = "\(baseUrl)?collectible=1"
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("9f50ede108msh2e2c844d51c5029p163294jsn98a1369fa434", forHTTPHeaderField: "X-RapidAPI-Key")
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) {
            (data, response, error) in
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        for setObject in json {
                            if !setObject.key.contains("Tavern Brawl")
                                && !setObject.key.contains("Missions")
                                && !setObject.key.contains("Debug")
                                && !setObject.key.contains("Promo")
                                && !setObject.key.contains("Hero Skins")
                                && !setObject.key.contains("Taverns of Time")
                                && !setObject.key.contains("System")
                                && !setObject.key.contains("Credits") {
                                setArray.append(setObject.key)
                            }
                        }
                        
                        let group = DispatchGroup()
                        group.enter()
                        
                        DispatchQueue.main.async {
                            self.setNames = setArray.sorted()
                            print("Set Count: \(self.setNames.count)")
                            ProgressCount.progress = Progress(totalUnitCount: Int64(self.setNames.count))
                            print("Completed fetching: Set Names *")
                            group.leave()
                        }
                        
                        group.notify(queue: .main) {
                            for name in self.setNames {
                                self.fetchCards(from: name, completion: { (cards:[Card]) in
                                    for card in cards {
                                        for set in self.standardSets {
                                            if card.cardSet.elementsEqual(set) {
                                                self.standardCards.append(card)
                                            }
                                        }
                                        self.allCards.append(card)
                                    }
                                    print("Completed fetching: \(name) to All Cards **")
                                    
                                    if ProgressCount.progressCount == self.setNames.count {
                                        print("*** Completed fetching all cards ***")
                                        print("\(CardsAPI.collection.standardCards.count)")
                                        print("\(CardsAPI.collection.allCards.count)")
                                        
                                        CardData.data.saveCards()
                                    }
                                })
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func fetchCards(from set:String, completion: @escaping ([Card]) -> ()) {
        
        let setUrl = set.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "\(baseUrl)/sets/\(setUrl!)?collectible=1"
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("9f50ede108msh2e2c844d51c5029p163294jsn98a1369fa434", forHTTPHeaderField: "X-RapidAPI-Key")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            print("** Started fetching: \(set)")
            
            var cardArray:[Card] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]] {
                        for cardData in json {
                            let cardObject = Card(json: cardData)
                            if !cardObject.cardId.contains("HERO_0") {
                                cardArray.append(cardObject)
                            }
                        }
                        
                        let group = DispatchGroup()
                        group.enter()
                        
                        DispatchQueue.main.async {
                            ProgressCount.progressCount += 1
                            group.leave()
                        }
                        
                        group.notify(queue: .main) {
                            print("\(ProgressCount.progressCount)")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(cardArray)
            }
        }
        
        task.resume()
    }
    
}
