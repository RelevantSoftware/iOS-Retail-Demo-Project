//
//  Card+CoreDataClass.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 22.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MagicalRecord

let keyCardClassName = "Card"
let keyCardName = "name"
let keyCardCode = "code"
let keyCardSelectingDate = "lastSelectingDate"

public class Card: NSManagedObject, NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: keyCardName)
        aCoder.encode(code, forKey: keyCardCode)
    }

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    required public init(coder aDecoder: NSCoder) {

        let ctx = NSManagedObjectContext.mr_default()
        let entity = NSEntityDescription.entity(forEntityName: keyCardClassName, in: ctx)!

      //   Note: pass `nil` to `insertIntoManagedObjectContext`
        super.init(entity: entity, insertInto: nil)

//        for attribute:String in self.entity.attributesByName.keys{
//            self.setValue([aDecoder.decodeObject(forKey: attribute)], forKey: attribute)
//        }
        self.name = aDecoder.decodeObject(forKey:keyCardName) as! String?
        self.code = aDecoder.decodeObject(forKey: keyCardCode) as! String?
        self.lastSelectingDate = aDecoder.decodeObject(forKey: keyCardSelectingDate) as! Date?

}

    class func unArchiveAndSaveCard(data: Data){
        NSKeyedUnarchiver.setClass(Card.self, forClassName: keyCardClassName)
        if let card = NSKeyedUnarchiver.unarchiveObject(with: data) as? Card {
            MagicalRecord.save(blockAndWait: { (context) -> Void in

                let newCard = Card.mr_createEntity(in: context)
                newCard?.name = card.name
                newCard?.code = card.code
                newCard?.lastSelectingDate = card.lastSelectingDate
                
            })
        }
    }

    class func deleteFromStorageCardWithCode(code: String ) {
        MagicalRecord.save(blockAndWait: { (context) in
            Card.mr_deleteAll(matching: NSPredicate(format: "code == \(code)"), in: context)
        })
        CardManager().deleteImage(code: code)
    }


}
