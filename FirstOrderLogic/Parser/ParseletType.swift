//
//  ParseletType.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 31/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

protocol PrefixParseletType {
    func parseExpressionForParser(parser: Parser) -> ExpressionType?
}

protocol InfixParseletType {
    func precedenceForExpression(lhs: ExpressionType, forParser parser: Parser) -> Double
    func parseExpression(lhs: ExpressionType, forParser parser: Parser) -> ExpressionType?
}