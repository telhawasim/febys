//
//  VariantEntity+CoreDataProperties.swift
//  
//
//  Created by Waseem Nasir on 23/08/2021.
//
//

import Foundation
import CoreData


extension VariantEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VariantEntity> {
        return NSFetchRequest<VariantEntity>(entityName: "VariantEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var price: Double
    @NSManaged public var images: Data?

}
