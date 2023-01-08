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
    
    // MARK: - Static global calls
    
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
    
    static func fetchFeed() -> [Broadcast] {
        let request: NSFetchRequest = Broadcast.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.resultType = .managedObjectResultType
        return (DB.shared.fetch(request: (request as? NSFetchRequest<NSFetchRequestResult>)!) as [AnyObject] as? [Broadcast])!
    }
    
    static func insertFeed(_ feed: DataType.Feed) {
        UserDefaults.standard.set(Date().milliseconds, forKey: Constants.lastFeedCheck)
        feed.broadcasts?.forEach({ broadcast in
            let check = DB.shared.find(.Broadcast, predicate: NSPredicate(format: "id = %@", broadcast.id!))
            if check.count > 0 {
                
            }else {
                let new = Broadcast(context: DB.shared.context)
                new.id = broadcast.id
                new.body = broadcast.body
                new.created = broadcast.created
                new.media = broadcast.media
                new.media_type = broadcast.media_type?.rawValue
                new.user = User(context: DB.shared.context)
                new.user?.profile_photo = broadcast.user?.profile_photo
                new.user?.username = broadcast.user?.username
                new.user?.name = broadcast.user?.name
                new.user?.id = broadcast.user?.id
                DB.shared.save()
            }
        })
    }
    
    
    // MARK: - Base functions
    
    @discardableResult func insert(_ model: Model, keyValue: Dictionary<String, Any>) -> Bool {
        let record = NSEntityDescription.insertNewObject(forEntityName: model.rawValue, into: context)
        keyValue.forEach({ item in
            record.setValue(item.value, forKey: item.key)
        })
        return save()
    }
    
    func findById(_ model: Model, id: String) -> NSManagedObject? {
        let find = self.find(model, predicate: NSPredicate(format: "id = %@", id))
        if find.count > 0 {
            return find[0]
        }else {
            return nil
        }
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
    
    // MARK: - Private primaries
    
    @discardableResult public func save() -> Bool{
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
