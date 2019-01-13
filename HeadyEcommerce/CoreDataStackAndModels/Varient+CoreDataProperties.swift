//
//  Varient+CoreDataProperties.swift
//  
//
//  Created by Roshan Soni on 12/01/19.
//
//

import Foundation
import CoreData


extension Varient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Varient> {
        return NSFetchRequest<Varient>(entityName: "Varient")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int64
    @NSManaged public var price: Float
    @NSManaged public var size: Int64
    @NSManaged public var product: Product?
}
