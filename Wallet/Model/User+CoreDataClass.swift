//
//  User+CoreDataClass.swift
//  
//
//  Created by Hackr on 1/9/19.
//
//
//
//import Foundation
//import CoreData
//
//@objc(User)
//public class User: NSManagedObject {
//
//    static func addContact(uuid: String,
//                           name: String,
//                           publicKey: String,
//                           image: String,
//                           context: NSManagedObjectContext) -> User {
//        let request: NSFetchRequest<User> = User.fetchRequest()
//        request.predicate = NSPredicate(format: "uuid = %@", uuid)
//        do {
//            let matches = try context.fetch(request)
//            if matches.count > 0 {
//                assert(matches.count == 1, "Payment.findOrCreateStatus -- Database inconsistency")
//                return matches[0]
//            }
//        } catch {
//            let error = error
//            print(error.localizedDescription)
//        }
//        let user = User(context: context)
//        user.uuid = uuid
//        user.email = email
//        PersistenceService.saveContext()
//        return payment
//    }
//    }
//    
////    static func fetchContacts(
////        let request: NSFetchRequest<Payment> = Payment.fetchRequest()
////        request.predicate = NSPredicate(format: "id = %@", id)
////        do {
////        let matches = try context.fetch(request)
////        if matches.count > 0 {
////        assert(matches.count == 1, "Payment.findOrCreateStatus -- Database inconsistency")
////        return matches[0]
////        }
////        } catch {
////        let error = error
////        print(error.localizedDescription)
////    }
////    let payment = Payment(context: context)
////    payment.id = id
////    payment.assetCode = assetCode
////    payment.issuer = issuer
////    payment.amount = amount
////    payment.to = to
////    payment.from = from
////    payment.timestamp = timestamp
////    payment.isReceived = isReceived
////    PersistenceService.saveContext()
////    return payment
////})
//    
//    
//}
