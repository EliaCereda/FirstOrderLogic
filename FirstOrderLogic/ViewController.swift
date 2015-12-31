//
//  ViewController.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 27/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate {

    @IBOutlet var inputTextView: NSTextView!
    @IBOutlet weak var tokenTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func textDidChange(notification: NSNotification) {
        let input = inputTextView.string!
        
        let tokens = Tokenizer().parseString(input).lazy.filter { $0.kind != .Space }
        
        
        let language = Language(predicates: [ Predicate(name: "A"), Predicate(name: "B"), Predicate(name: "C") ])
        let expr = Parser(tokens: tokens, language: language).parseExpression()
        
        tokenTextField.stringValue = Array(tokens).description + "\n" + String(expr)
    }
}

