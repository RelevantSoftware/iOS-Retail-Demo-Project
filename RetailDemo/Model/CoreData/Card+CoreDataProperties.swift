//
//  Card+CoreDataProperties.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 22.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: keyCardClassName);
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?
    @NSManaged public var lastSelectingDate : Date?

}
