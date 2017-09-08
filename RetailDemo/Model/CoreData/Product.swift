//
//  Product.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 3/1/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {
    
    @NSManaged public var productID: String
    @NSManaged public var isWished: Bool
    @NSManaged public var isToBuy: Bool
    @NSManaged public var price: Int32
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var unit: String?
    @NSManaged public var urlString: String?
    @NSManaged public var barcode: String?
    @NSManaged public var images: String?
    @NSManaged public var createdByUser: Bool

}
