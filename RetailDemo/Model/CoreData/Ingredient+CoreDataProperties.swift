//
//  Ingredient+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient");
    }

    @NSManaged public var amount: Float
    @NSManaged public var productName: String?
	@NSManaged public var ingredientID: Int32
}
