//
//  AppDelegate.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 27/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

import Cocoa

struct Language: LanguageType {
    let functions: [String: FunctionType]
    let predicates: [String: PredicateType]
    let constants: [String: ConstantType]
    
    init(functions: [FunctionType] = [], predicates: [PredicateType] = [], constants: [ConstantType] = []) {
        self.functions = functions.indexBy { return $0.name }
        self.predicates = predicates.indexBy { return $0.name }
        self.constants = constants.indexBy { return $0.name }
    }
    
    func hasSymbolWithName(name: String) -> Bool {
        return functions[name] != nil || predicates[name] != nil || constants[name] != nil
    }
    
    // MARK: LanguageType
    
    func function(named name: String) -> FunctionType? {
        return functions[name]
    }
    
    func predicate(named name: String) -> PredicateType? {
        return predicates[name]
    }
    
    func constant(named name: String) -> ConstantType? {
        return constants[name]
    }
    
    func variable(named name: String) -> VariableType? {
        guard !hasSymbolWithName(name) else {
            return nil
        }
        
        return Variable(name: name)
    }
}

struct Variable: VariableType {
    let name: String
}

struct Predicate: PredicateType {
    let name: String
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
//        let tokens = Tokenizer().parseString("∀x∀y ~A ∧ ∀z B -> \\exists u C").lazy.filter { $0.kind != .Space }
        let tokens = Tokenizer().parseString("((∀x(∀y (~A))) ∧ (∀z B)) -> (\\exists u C)").lazy.filter { $0.kind != .Space }
        
        let language = Language(predicates: [ Predicate(name: "A"), Predicate(name: "B"), Predicate(name: "C") ])
        let expr = Parser(tokens: tokens, language: language).parseExpression()
        
        print(Array(tokens))
        print(expr)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

