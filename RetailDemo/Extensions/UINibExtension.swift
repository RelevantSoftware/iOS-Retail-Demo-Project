//
//  UINibExtension.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

extension UINib {
    
    enum Name: String {
        case productTableViewCell = "ProductTableViewCell"
        case recipeTableViewCell = "RecipeTableViewCell"
        case cardTableViewCell = "CardTableViewCell"

    }
    
    class func nib(_ name: Name, inBundle bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: name.rawValue, bundle: bundle)
    }
}
