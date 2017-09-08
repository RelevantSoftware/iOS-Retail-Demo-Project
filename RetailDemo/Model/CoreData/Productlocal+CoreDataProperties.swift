//
//  Productlocal+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 16.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension Productlocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Productlocal> {
        return NSFetchRequest<Productlocal>(entityName: "Productlocal");
    }

    @NSManaged public var isToBuy: Bool
    @NSManaged public var isWished: Bool
    @NSManaged public var price: Int32
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var unit: String?
    @NSManaged public var urlString: String?

}
