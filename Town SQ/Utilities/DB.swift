//
//  DB.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 29/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DB: NSObject {
    
    static let shared: DB = {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        return DB(context: delegate.persistentContainer.viewContext)
    }()
    
    enum Model: String {
        case User
    }
    
    let ModelClass: Dictionary<Model, AnyClass> = [
        .User: User.self,
    ]
    
    let context : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    static func UserRecord() -> User? {
        let records = DB.shared.find(.User, predicate: NSPredicate(format: "primary = %@", NSNumber(booleanLiteral:  true)))
        if records.count > 0 {
            return records[0] as? User
        }
        return nil
    }
    
    // Base func
    
    @discardableResult func insert(_ model: Model, keyValue: Dictionary<String, Any>) -> Bool {
        let record = NSEntityDescription.insertNewObject(forEntityName: model.rawValue, into: context)
        keyValue.forEach({ item  in
            record.setValue(item.value, forKey: item.key)
        })
        return save()
    }
    
    func find(_ model: Model, predicate: NSPredicate?) -> [NSManagedObject] {
        let type: AnyClass? = ModelClass[model]
        let request: NSFetchRequest = type?.fetchRequest() as! NSFetchRequest
        if predicate != nil {
            request.predicate = predicate
        }
        request.returnsObjectsAsFaults = false
        return fetch(request: request)
    }
    
    @discardableResult func update(_ model: Model, predicate: NSPredicate?, keyValue: Dictionary<String, Any>) -> Bool {
        let records = find(model, predicate: predicate)
        if records.count < 1 {
            return false
        }
        let record = records[0]
        keyValue.forEach({ item  in
            record.setValue(item.value, forKey: item.key)
        })
        return save()
    }
    
    @discardableResult func delete(_ model: Model, predicate: NSPredicate?) -> Bool {
        let records = find(model, predicate: predicate)
        for record in records {
            context.delete(record)
        }
        return save()
    }
    
    @discardableResult func drop(_ model: Model) -> Bool {
        return delete(model, predicate: nil)
    }
    
    // private primaries
    
    private func save() -> Bool{
        do{
            try context.save()
            return true
        }catch let e as NSError {
            NSLog("DB :: SAVING :: Error encountered: \(e.description)")
        }
        return false
    }
    
    private func fetch(request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]{
        do {
            let result = try context.fetch(request)
            return result as! [NSManagedObject]
        }catch let e as NSError {
            NSLog("DB :: FETCHING :: Error encountered: \(e.description)")
        }
        return []
    }

}
