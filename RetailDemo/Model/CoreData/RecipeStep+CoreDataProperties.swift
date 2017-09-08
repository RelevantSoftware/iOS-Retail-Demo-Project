//
//  RecipeStep+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension RecipeStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeStep> {
        return NSFetchRequest<RecipeStep>(entityName: "RecipeStep");
    }

    @NSManaged public var text: String?
    @NSManaged public var image: String?
    @NSManaged public var order: Int16
    @NSManaged public var recipeStepID: Int32

}
