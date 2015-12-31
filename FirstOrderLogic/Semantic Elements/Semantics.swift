//
//  Semantics.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 31/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

protocol LanguageType {
    func function(named name: String) -> FunctionType?
    func predicate(named name: String) -> PredicateType?
    func constant(named name: String) -> ConstantType?
    func variable(named name: String) -> VariableType?
}

protocol SymbolType {
    var name: String { get }
}

protocol VariableType: SymbolType {
    
}

protocol ConstantType: SymbolType {
    
}

protocol FunctionType: SymbolType {
    
}

protocol PredicateType: SymbolType {
    
}
