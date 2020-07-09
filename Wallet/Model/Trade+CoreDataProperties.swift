//
//  Trade+CoreDataProperties.swift
//  
//
//  Created by Hackr on 2/6/20.
//
//

import Foundation
import CoreData


extension Trade {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trade> {
        return NSFetchRequest<Trade>(entityName: "Trade")
    }

    @NSManaged public var baseAccount: String?
    @NSManaged public var baseAmount: String?
    @NSManaged public var baseAssetCode: String?
    @NSManaged public var counterAccount: String?
    @NSManaged public var counterAmount: String?
    @NSManaged public var counterAssetCode: String?
    @NSManaged public var id: String?
    @NSManaged public var status: String?
    @NSManaged public var price: String?
    @NSManaged public var subtotal: String?
    @NSManaged public var fee: String?
    @NSManaged public var size: String?
    @NSManaged public var side: String?
    @NSManaged public var timestamp: Date
    @NSManaged public var total: String?

}
