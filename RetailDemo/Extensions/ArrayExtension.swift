//
//  ArrayExtension.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 3/1/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation

extension Array {
    
    func groupBy<T: Hashable>(groupClosure: (Element) -> T) -> [[Element]] {
        var dictionary = [T: [Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var array: [Element]? = dictionary[key]
            
            if (array == nil) {
                array = [Element]()
            }
            
            array!.append(element)
            dictionary[key] = array!
        }
        
        var array: [[Element]] = []
        for key in dictionary.keys {
            if let value = dictionary[key] {
                array.append(value)
            }
        }
        return array
    }
}
