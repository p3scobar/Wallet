//
//  Trade+CoreDataClass.swift
//  
//
//  Created by Hackr on 2/6/20.
//
//

import Foundation
import CoreData

@objc(Trade)
public class Trade: NSManagedObject {

    static func findOrCreateTrade(id: String,
                                  status: String,
                                  timestamp: Date,
                                  size: String,
                                  price: String,
                                  subtotal: String,
                                  fee: String,
                                  total: String,
                                  side: String,
                                  baseAssetCode: String,
                                  baseAccount: String,
                                  baseAmount: String,
                                  counterAssetCode: String,
                                  counterAccount: String,
                                  counterAmount: String,
                                  in context: NSManagedObjectContext) -> Trade {
        
        let request: NSFetchRequest<Trade> = Trade.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                //assert(matches.count == 1, "Payment.findOrCreateStatus -- Database inconsistency")
                return matches[0]
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let trade = Trade(context: context)
        trade.id = id
        trade.status = status
        trade.timestamp = timestamp
        trade.size = size
        trade.price = price
        trade.subtotal = subtotal
        trade.fee = fee
        trade.total = total
        trade.side = side
        trade.baseAssetCode = baseAssetCode
        trade.baseAccount = baseAccount
        trade.baseAmount = baseAmount
        trade.counterAssetCode = counterAssetCode
        trade.counterAccount = counterAccount
        trade.counterAmount = counterAmount
        
        PersistenceService.saveContext()
        return trade
    }
    
    
    static func getAll(assetCode: String) -> [Trade] {
        let context = PersistenceService.context
        let request: NSFetchRequest<Trade> = Trade.fetchRequest()
        request.predicate = NSPredicate(format: "baseAssetCode = %@", assetCode)
        let timestamp = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [timestamp]
        var trades: [Trade] = []
        do {
            trades = try context.fetch(request)
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        return trades
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Trade")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let container = PersistenceService.persistentContainer
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
