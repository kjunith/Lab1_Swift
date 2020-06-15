//
//  CardsDelegate.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-26.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


protocol CardsDelegate {
    func addCardToDeck(card: Card) -> Bool
    func removeCardFromDeck(card: Card) -> Bool
}
