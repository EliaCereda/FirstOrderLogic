//
//  Parser.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 31/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

class Parser {
    var tokens: PeekableGenerator<Token>
    let language: LanguageType
    
    init<S: SequenceType where S.Generator.Element == Token>(tokens: S, language: LanguageType) {
        self.tokens = PeekableGenerator(tokens.generate())
        self.language = language
    }
    
    // MARK: Parselet Interface
    
    var nextToken: Token? { return tokens.peek() }
    
    func consumeToken() -> Token? {
        return tokens.next()
    }
    
    func consumeTokenIf(matches: (Token) -> Bool) -> Token? {
        guard let token = self.nextToken else {
            return nil
        }
        
        if matches(token) {
            return self.consumeToken()
        } else {
            return nil
        }
    }
    
    func consumeTokenIf(kind kind: Token.Kind) -> Token? {
        return consumeTokenIf { $0.kind == kind }
    }
    
    func discardTokenIf(kind kind: Token.Kind) -> BooleanType {
        return consumeTokenIf(kind: kind) != nil
    }
    
    func consumeTokenIf(kinds kinds: Set<Token.Kind>) -> Token? {
        return consumeTokenIf { kinds.contains($0.kind) }
    }
    
    // MARK: Parser
    
    func parseTerm() -> TermType? {
        guard let symbol = self.consumeTokenIf(kind: .Symbol) else {
            print("Expected term")
            return nil
        }
        
        let name = symbol.source
        
        if let predicate = self.language.predicate(named: name) {
            print("Expected term, found predicate \(predicate)")
            return nil
        }
        
        if let function = self.language.function(named: name) {
            guard let terms = self.parseTermList() else {
                print("Expected term list")
                return nil
            }
            
            return FunctionApplication(function: function, terms: terms)
        }
        
        if let constant = self.language.constant(named: name) {
            return ConstantTerm(constant: constant)
        }
        
        if let variable = self.language.variable(named: name) {
            return VariableTerm(variable: variable)
        }
        
        print("Expected term, found unknown symbol")
        return nil
    }
    
    func parseTermList() -> [TermType]? {
        guard self.discardTokenIf(kind: .ParenthesisLeft) else {
            return nil
        }
        
        var terms = [TermType]()
        
        if self.nextToken?.kind != .ParenthesisRight {
            repeat {
                guard let term = self.parseTerm() else {
                    return nil
                }
                
                terms.append(term)
            } while self.discardTokenIf(kind: .Comma)
        }
        
        guard self.discardTokenIf(kind: .ParenthesisRight) else {
            print("Expected right parenthesis")
            return nil
        }
        
        return terms
    }
    
    func parseAtom() -> AtomType? {
        if self.discardTokenIf(kind: .True) {
            return BooleanAtom(value: true)
        }
        
        if self.discardTokenIf(kind: .False) {
            return BooleanAtom(value: false)
        }
        
        if let symbol = self.consumeTokenIf(kind: .Symbol) {
            let name = symbol.source
            
            guard let predicate = self.language.predicate(named: name) else {
                print("Expected predicate, got symbol \(symbol)")
                return nil
            }
            
            let terms = self.parseTermList() ?? []
            
            return PredicateApplication(predicate: predicate, terms: terms)
        }
        
        print("Expected atom")
        return nil
    }
    
    func parsePrefixExpression() -> ExpressionType? {
        if self.discardTokenIf(kind: .ParenthesisLeft) {
            let expr = self.parseExpression()
            
            guard self.discardTokenIf(kind: .ParenthesisRight) else {
                print("Expected right parenthesis")
                return nil
            }
            
            return expr
        }
        
        if let token = self.consumeTokenIf(kind: .Not) {
            guard let expr = self.parseExpression(precedenceForToken(token)) else {
                return nil
            }
            
            return LogicalExpression(operation: .Not, expressions: [expr])
        }
        
        if let token = self.consumeTokenIf(kinds: [.ForAll, .Exists]) {
            let quantifier: Quantifier = (token.kind == .ForAll) ? .ForAll : .Exists
            
            guard let symbol = self.consumeTokenIf(kind: .Symbol) else {
                print("Expected term")
                return nil
            }
            
            let name = symbol.source
            
            guard let variable = self.language.variable(named: name) else {
                print("Expected variable, got symbol \(symbol)")
                return nil
            }
            
            guard let expr = self.parseExpression(precedenceForToken(token)) else {
                return nil
            }
            
            return BindingExpression(quantifier: quantifier, variable: variable, expression: expr)
        }
        
        return self.parseAtom()
    }
    
    func parseInfixExpression(lhs: ExpressionType) -> ExpressionType? {
        guard let token = self.consumeTokenIf(kinds: [.And, .Or, .Implies, .BiImplies]) else {
            print("Expected infix operator")
            return nil
        }
        
        let operation: Operation
        switch token.kind {
        case .And:
            operation = .And
        case .Or:
            operation = .Or
            
        case .Implies:
            operation = .Implies
        case .BiImplies:
            operation = .BiImplies
            
        default:
            preconditionFailure()
        }
        
        // Reduce precedence to get right-associative behavior
        let precedence = precedenceForToken(token) - 1
        
        guard let rhs = self.parseExpression(precedence) else {
            print("Expected right hand side")
            return nil
        }
        
        return LogicalExpression(operation: operation, expressions: [lhs, rhs])
    }
    
    func precedenceForNextExpression() -> Double {
        if let token = self.nextToken {
            return precedenceForToken(token)
        } else {
            return -Double.infinity
        }
    }
    
    func precedenceForToken(token: Token) -> Double {
        let precedences: [Token.Kind : Double] = [
            .BiImplies: 10,
            .Implies: 20,
            
            .Or: 30,
            .And: 40,
            
            .Not: 50,
            
            .Exists: 60,
            .ForAll: 70
        ]
        
        return precedences[token.kind] ?? -Double.infinity
    }
    
    func parseExpression(precedence: Double = 0) -> ExpressionType? {
        var lhs = self.parsePrefixExpression()
        
        while lhs != nil && precedence < self.precedenceForNextExpression() {
            lhs = self.parseInfixExpression(lhs!)
        }
        
        return lhs
    }
}
