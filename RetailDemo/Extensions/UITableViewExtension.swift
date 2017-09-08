//
//  UITableViewExtension.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/28/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import UIKit

extension UITableView {
    
    enum CellIdentifier: String {
        case productTableViewCell = "ProductTableViewCellIdentifier"
        case recipeTableViewCell = "RecipeTableViewCell"
        case cardTableViewCell = "CardTableViewCell"
    }
    
    func register(_ nib: UINib, forCell cellIdentifier: CellIdentifier) {
        self.register(nib, forCellReuseIdentifier: cellIdentifier.rawValue)
    }
    
    func dequeueCell(_ cellIdentifier: CellIdentifier,
        for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellIdentifier.rawValue,
            for: indexPath)
    }
}
