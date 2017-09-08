//
//  Shop+CoreDataClass.swift
//
//
//  Created by Alexey Romanko on 27.02.17.
//
//

import Foundation
import CoreData
import MagicalRecord
import MapKit

public class Shop: NSManagedObject, MKAnnotation {

    public var title: String? { get {
			return name ?? ""
        }
    }
    public var coordinate: CLLocationCoordinate2D { get {
        let c: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.lat, self.lon)
        return c
        }
    }

    class func arrayOfLocalShops(callback:@escaping ()->Void) {
        if let path = Bundle.main.path(forResource: "Shops", ofType: "plist") {
            if let arr = NSArray(contentsOfFile: path) as? [AnyObject] {
                 MagicalRecord.save({ (context) in
                for dict in arr {
                    if dict is [String:AnyObject] {
                        Shop.mr_import(from: dict, in: context)
                    }
                }
                 }, completion: { (success, err) in
                    callback()
                 })

            }
        }
    }

}
