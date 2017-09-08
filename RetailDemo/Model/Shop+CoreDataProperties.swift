//
//  Shop+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 27.02.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop");
    }

    @NSManaged public var address: String?
    @NSManaged public var url: String?
    @NSManaged public var name: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var shopID: String?

}
