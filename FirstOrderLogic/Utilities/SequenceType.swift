//
//  SequenceType.swift
//  FirstOrderLogic
//
//  Created by Elia Cereda on 31/12/15.
//  Copyright © 2015 Elia Cereda. All rights reserved.
//

extension SequenceType {
    func indexBy<K: Hashable>(index: (Generator.Element) -> K) -> [K : Generator.Element] {
        return self.reduce([:]) { (var dict, el) in
            let key = index(el)
            dict[key] = el
            
            return dict
        }
    }
}