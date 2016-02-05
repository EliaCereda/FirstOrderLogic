//
//  CollectionType.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 05/02/16.
//  Copyright © 2016 Elia Cereda. All rights reserved.
//

extension CollectionType {
    func startsWith<S : SequenceType where S.Generator.Element == Generator.Element>(other: S, @noescape isEquivalent: (Generator.Element, Generator.Element) throws -> Bool) rethrows -> Index? {
        var index = self.startIndex
        
        // If `self` starts with `other` this will have to iterate over the whole sequence
        for element in other {
            
            // `self` has to be at least as long as `other`, bail out if not
            if index == self.endIndex {
                return nil
            }
            
            // Bail out if different
            if try isEquivalent(self[index], element) == false {
                return nil
            }
            
            // The elements match, continue with the next pair
            index = index.successor()
        }
        
        return index
    }
}

extension CollectionType where Generator.Element: Equatable {
    func startsWith<C : CollectionType where C.Generator.Element == Generator.Element>(other: C) -> Index? {
        return startsWith(other, isEquivalent: ==)
    }
}
