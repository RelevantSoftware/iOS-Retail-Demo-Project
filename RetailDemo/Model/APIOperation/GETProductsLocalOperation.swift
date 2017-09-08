//
//  GETProductsOperation.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation

class GETProductsLocalOperation: APIOperation<[Productlocal]> {
    
    init(completion: Completion? = nil) {
        
        super.init(networkMethod: .local, path: "products",
           parameters: nil,
           completion: completion)
    }
}
