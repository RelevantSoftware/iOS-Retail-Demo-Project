//
//  UIStoryboardExtension.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum Name: String {
        case main = "Main"
        case product = "Product"
        case scanner = "Scanner"
        case recipe = "RecipesList"
    }
    
    enum ControllerIdentifier: String {
        case productsViewController = "ProductsViewControllerIdentifier"
        case productTableViewController = "ProductTableViewControllerIdentifier"
        case scannerViewController = "ScannerViewController"
        case recipeDetailViewController = "RecipeDetailViewController"
    }
    
    class func storyboard(_ name: Name,
        inBundle bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: bundle)
    }
    
    func instantiateViewController(_ controllerIdentifier: ControllerIdentifier) -> UIViewController {
        return self.instantiateViewController(withIdentifier: controllerIdentifier.rawValue)
    }
    
    class func instantiateViewController(_ controllerIdentifier: ControllerIdentifier,
        inStoryboard storyboardName: Name) -> UIViewController {
        let storyboard = self.storyboard(storyboardName)
        return storyboard.instantiateViewController(controllerIdentifier)
    }
}
