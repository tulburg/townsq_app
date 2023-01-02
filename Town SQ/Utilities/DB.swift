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
        case User, Broadcast, Comment
    }
    
    let ModelClass: Dictionary<Model, AnyClass> = [
        .User: User.self, .Broadcast: Broadcast.self, .Comment: Comment.self
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
    
    static func activeBroadcasts() -> [Broadcast]? {
        let activeBroadcast = DB.shared.find(.Broadcast, props: ["id"], predicate: NSPredicate(format: "active = %@", BroadcastType.Active.rawValue))
        return activeBroadcast as? [Broadcast]
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
        return self.find(model, props: nil, predicate: predicate)
    }
    
    func find(_ model: Model, props: [String]?, predicate: NSPredicate?) -> [NSManagedObject] {
        let type: AnyClass? = ModelClass[model]
        let request: NSFetchRequest = type?.fetchRequest() as! NSFetchRequest
        if predicate != nil {
            request.predicate = predicate
        }
        if props != nil {
            request.propertiesToFetch = props!
            request.resultType = .managedObjectResultType
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

extension NSManagedObject {
    func object() -> [String: Any] {
        func parseValue(_ value: Any) -> Any {
            if value is Date {
                return (value as! Date).milliseconds
            }else {
                return value
            }
        }
        let keys = Array(self.entity.attributesByName.keys)
        var result: [String: Any] = [:]
        self.dictionaryWithValues(forKeys: keys).forEach{ key, value in
            result[key] = parseValue(value)
        }
        return result
    }
}

enum BroadcastType: String {
    case Active, Normal
}
