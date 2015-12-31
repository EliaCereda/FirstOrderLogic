//
//  Tokenizer.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 27/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

import Foundation

class Tokenizer {
    func parseString(string: String) -> AnySequence<Token> {
        return AnySequence() { () -> AnyGenerator<Token> in
            var index = string.startIndex
            
            return anyGenerator() {
                if index == string.endIndex {
                    return nil
                }
                
                if let token = self.parseTokenInString(string, startingAtIndex: index) {
                    index = token.location.endIndex
                    
                    return token
                }
                
                return nil
            }
        }
    }
    
    func parseTokenInString(string: String, startingAtIndex startIndex: String.Index) -> Token? {
        var index = startIndex
        
        var character: Character { return string[index] }
        var stringView: String.CharacterView { return string.characters[index ..< string.endIndex] }
        
        func tokenWithKind(kind: Token.Kind) -> Token {
            let endIndex = (index == startIndex) ? index.successor() : index
            let location = startIndex ..< endIndex
            let source = string[location]
            
            return Token(kind: kind, source: source, location: location)
        }
        
        // Single-Character Tokens
        
        if let kind = self.singleCharacterTokens[character] {
            return tokenWithKind(kind)
        }
        
        // Keyword Tokens
        
        for (keyword, token) in self.keywordTokens {
            let keyword = keyword.characters
            
            if stringView.startsWith(keyword) {
                index = startIndex.advancedBy(keyword.count)
                
                // Keyword Tokens must be followed by a space or the end of the string
                //
                if index != string.endIndex && character != " " {
                    print("Keyword token not terminated")
                    return nil
                }
                
                return tokenWithKind(token)
            }
        }
        
        // Symbols
        
        if self.symbolFirstCharacter.characterIsMember(character) {
            repeat {
                index = index.successor()
            } while index != string.endIndex && self.symbolOtherCharacters.characterIsMember(character)
            
            return tokenWithKind(.Symbol)
        }
        
        // Unknown Tokens
        print("Unknown token")
        return nil
    }
    
    private let singleCharacterTokens: [Character : Token.Kind] = [
        " ": .Space,
        
        "(": .ParenthesisLeft,
        ")": .ParenthesisRight,
        
        ",": .Comma,
        
        "∀": .ForAll,
        "∃": .Exists,
        
        "⊤": .True,
        "⊥": .False,
        
        "∧": .And,
        "∨": .Or,
        
        "¬": .Not,
        "~": .Not,
        
        "→": .Implies,
        "↔": .BiImplies,
    ]
    
    private let keywordTokens: [String : Token.Kind] = [
        "\\forall": .ForAll,
        "\\exists": .Exists,
        
        "T": .True,
        "\\true": .True,
        
        "F": .False,
        "\\false": .False,
        
        "\\and": .And,
        "\\or": .Or,
        
        "\\not": .Not,
        
        "->": .Implies,
        "\\implies": .Implies,
        
        "<->": .BiImplies,
        "\\biimplies": .BiImplies,
        "\\iff": .BiImplies,
    ]
    
    private let symbolFirstCharacter = NSCharacterSet.letterCharacterSet()
    private let symbolOtherCharacters = NSCharacterSet.alphanumericCharacterSet()
}
