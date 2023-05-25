//
//  CartItemEntity+CoreDataProperties.swift
//  
//
//  Created by Waseem Nasir on 23/08/2021.
//
//

import Foundation
import CoreData


extension CartItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItemEntity> {
        return NSFetchRequest<CartItemEntity>(entityName: "CartItemEntity")
    }

    @NSManaged public var quantity: Int64
    @NSManaged public var product: ProductEntity?

}
