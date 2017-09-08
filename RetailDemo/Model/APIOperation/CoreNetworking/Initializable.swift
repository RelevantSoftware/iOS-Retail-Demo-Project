//
//  Creatable.swift
//

import Foundation
import CoreData

protocol Initializable {
    init()
}

extension NSNull: Initializable {
}

extension NSManagedObject: Initializable {
}

extension Array: Initializable {
    
}

extension Dictionary: Initializable {
    
}
