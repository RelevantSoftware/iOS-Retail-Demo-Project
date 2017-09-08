//
//  Recipe+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var steps: NSSet?
    @NSManaged public var ingridients: NSSet?

}
