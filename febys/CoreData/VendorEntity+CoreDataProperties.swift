//
//  VendorEntity+CoreDataProperties.swift
//  
//
//  Created by Waseem Nasir on 23/08/2021.
//
//

import Foundation
import CoreData


extension VendorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VendorEntity> {
        return NSFetchRequest<VendorEntity>(entityName: "VendorEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var storeName: String?
    @NSManaged public var vendorAmount: Double
    @NSManaged public var individualVendorType: Int64
    @NSManaged public var email: String?
    @NSManaged public var phoneNumber: String?

}
