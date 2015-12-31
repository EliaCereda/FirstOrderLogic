//
//  ExpressionType.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 30/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

protocol ExpressionType {

}

protocol AtomType: ExpressionType {
    
}

protocol TermType {
    
}

// MARK: Terms

struct VariableTerm: TermType {
    let variable: VariableType
}

struct ConstantTerm: TermType {
    let constant: ConstantType
}

struct FunctionApplication: TermType {
    let function: FunctionType
    let terms: [TermType]
}

// MARK: Atoms

struct BooleanAtom: AtomType {
    let value: Bool
}

struct PredicateApplication: AtomType {
    let predicate: PredicateType
    let terms: [TermType]
}

// MARK: Expressions

enum Operation {
    case Not
    case And
    case Or
    case Implies
    case BiImplies
    
    var arity: UInt { return (self == .Not) ? 1 : 2 }
}

struct LogicalExpression: ExpressionType {
    let operation: Operation
    let expressions: [ExpressionType]
}

enum Quantifier {
    case ForAll
    case Exists
}

struct BindingExpression: ExpressionType {
    let quantifier: Quantifier
    let variable: VariableType
    let expression: ExpressionType
}

