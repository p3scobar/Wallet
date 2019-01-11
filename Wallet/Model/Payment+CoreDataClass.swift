//
//  Payment+CoreDataClass.swift
//  
//
//  Created by Hackr on 12/6/18.
//
//

import Foundation
import CoreData

@objc(Payment)
public class Payment: NSManagedObject {
    
    static func findOrCreatePayment(id: String,
                                    assetCode: String,
                                    issuer: String,
                                    amount: String,
                                    to: String,
                                    from: String,
                                    timestamp: Date,
                                    in context: NSManagedObjectContext) -> Payment {
        
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Payment.findOrCreateStatus -- Database inconsistency")
                return matches[0]
            }
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        let payment = Payment(context: context)
        payment.id = id
        payment.assetCode = assetCode
        payment.issuer = issuer
        payment.amount = amount
        payment.to = to
        payment.from = from
        payment.timestamp = timestamp
        PersistenceService.saveContext()
        return payment
    }
    
    
    static func fetchPayments(forAsset assetCode: String) -> [Payment] {
        let context = PersistenceService.context
        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
        request.predicate = NSPredicate(format: "assetCode = %@", assetCode)
        let timestamp = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [timestamp]
        var payments: [Payment] = []
        do {
            payments = try context.fetch(request)
        } catch {
            let error = error
            print(error.localizedDescription)
        }
        return payments
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Payment")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let container = PersistenceService.persistentContainer
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
