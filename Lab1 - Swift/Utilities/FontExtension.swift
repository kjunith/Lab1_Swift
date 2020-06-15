//
//  FontExtension.swift
//  Swift - Lab1
//
//  Created by Jimmie Määttä on 2019-03-22.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit


extension UIFont {
    var bold: UIFont { return with(traits: .traitBold) }
    
    var italic: UIFont { return with(traits: .traitItalic) }
    
    var boldItalic: UIFont { return with(traits: [.traitBold, .traitItalic]) }
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}
