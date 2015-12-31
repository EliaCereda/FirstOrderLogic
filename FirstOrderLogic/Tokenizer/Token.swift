//
//  Token.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 27/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

struct Token {
    enum Kind {
        case Space
        
        case ParenthesisLeft
        case ParenthesisRight
        
        case Comma
        
        case ForAll
        case Exists
        
        case True
        case False
        
        case And
        case Or
        case Not
        case Implies
        case BiImplies
        
        case Symbol
    }
    
    let kind: Kind
    
    let source: String
    let location: Range<String.Index>
}

extension Token: CustomStringConvertible {
    var description: String {
        if self.kind == .Symbol {
            return "\"\(self.source)\""
        } else {
            return "\(self.kind)"
        }
    }
}
