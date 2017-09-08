//
//  Recipe+CoreDataClass.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 03.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord


public class Recipe: NSManagedObject {

    class func arrayOfLocalRecipes(callback:@escaping ()->Void) {
        if let path = Bundle.main.path(forResource: "Recipes", ofType: "plist") {
            if let arr = NSArray(contentsOfFile: path) as? [AnyObject] {
                print (arr)
                MagicalRecord.save({ (context) in
                    for dict in arr {
                        if dict is [String:AnyObject] {
                            Recipe.mr_import(from: dict, in: context)
                        }
                    }
                }, completion: { (success, err) in
                    callback()
                })

            }
        }
    }

}
