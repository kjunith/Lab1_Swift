//
//  AddCardProtocol.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-26.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import Foundation


protocol AddCardsDelegate {
    func addCardToDeck(card:Card) -> Bool
}
