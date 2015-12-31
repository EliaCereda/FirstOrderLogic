//
//  NSCharacterSet.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 27/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

import Foundation

extension NSCharacterSet {
    func characterIsMember(character: Character) -> Bool {
        let scalars = Array(String(character).unicodeScalars)
        
        if scalars.count != 1 {
            assertionFailure("ExtendedGraphemeClusters are not supported")
            return false
        }
        
        return self.longCharacterIsMember(scalars.first!.value)
    }
}