//
//  PeekableGenerator.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 31/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

struct PeekableGenerator<Element>: GeneratorType {
    
    var generator: AnyGenerator<Element>
    var buffer = [Element]()
    
    init<G: GeneratorType where G.Element == Element>(_ generator: G) {
        self.generator = anyGenerator(generator)
    }
    
    mutating func next() -> Element? {
        if let element = buffer.first {
            buffer.removeFirst()
            return element
        } else {
            return generator.next()
        }
        
        
    }
    
    mutating func peek() -> Element? {
        if buffer.isEmpty {
            if let element = generator.next() {
                buffer.append(element)
            }
        }
        
        return buffer.first
    }
}
