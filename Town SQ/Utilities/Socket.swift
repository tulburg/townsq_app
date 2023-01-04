//
//  Socket.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 30/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation
import SocketIO
import CoreData

class Socket {
    
    var socket: SocketIOClient!
    var user: User!
    var lastJob: (() -> Void)? = nil
    var broadcast: String!
    var comment: String!
    
    static let shared: Socket = {
        return Socket()
    }()
    
    func restart () {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.makeSocket()
        self.socket = delegate.socket
        user = DB.UserRecord()
        if user == nil {
            self.socket.disconnect()
            return
        }
        socket.on(clientEvent: .connect) { data, ack in
            let lastFeedCheck = UserDefaults.standard.string(forKey: Constants.lastFeedCheck)
            let activeBroadcasts = DB.activeBroadcasts()?.map{ $0.id }
            self.socket.emit("startup", [
                "lastFeedCheck": lastFeedCheck as Any ,
                "activeBroadcasts": activeBroadcasts as Any
            ])
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            
        }
        
        socket.on(Constants.Events.Startup) { data, ack in
            if let job = self.lastJob {
                job()
                self.lastJob = nil
            }
        }
        
        socket.on(Constants.Events.Broadcast) { data, ack in
            let response = Response<DataType.Broadcast>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                DB.shared.insert(.Broadcast, keyValue: [
                    "user": self.user as Any,
                    "body": self.broadcast as Any,
                    "created": response.data?.created as Any,
                    "id": response.data?.id as Any,
                    "active": BroadcastType.Active.rawValue
                ])
            }
            self.lastJob = nil
        }
        
        socket.on(Constants.Events.Comment) { data, ack in
            let response = Response<DataType.Comment>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                let broadcasts = DB.shared.find(.Broadcast, predicate: NSPredicate(format: "id = %@", (response.data?.broadcast_id)!))
                DB.shared.insert(.Comment, keyValue: [
                    "user": self.user as Any,
                    "body": self.comment as Any,
                    "created": response.data?.created as Any,
                    "id": response.data?.id as Any,
                    "broadcast": broadcasts[0] as Any
                ])
            }
            self.lastJob = nil
        }
        
        socket.on(Constants.Events.GotComment) { data, ack in
            let response = Response<DataType.NewComment>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                let broadcasts = DB.shared.find(.Broadcast, predicate: NSPredicate(format: "id = %@", (response.data?.broadcast_id)!))
                let users = DB.shared.find(.User, predicate: NSPredicate(format: "id = %@", (response.data?.user?.id)!))
                var user: User?
                if users.count > 0 {
                    user = (users[0] as? User)
                }
                if user == nil {
                    if let rUser = response.data?.user {
                        user = User(context: DB.shared.context)
                        user?.id = rUser.id
                        user?.name = rUser.name
                        user?.username = rUser.username
                        user?.profile_photo = rUser.profile_photo
                    }
                }
                DB.shared.insert(.Comment, keyValue: [
                    "user": user as Any,
                    "body": response.data?.body as Any,
                    "created": response.data?.created as Any,
                    "id": response.data?.id as Any,
                    "broadcast": broadcasts[0] as Any
                ])
            }
        }
        
        socket.on(Constants.Events.Feed) { data, ack in
            let response = Response<DataType.Feed>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                if let data = response.data {
                    DB.insertFeed(data)
                }
            }
            self.lastJob = nil
        }
        
        socket.onAny({ socket in
            print(socket)
        })
        
        socket.connect()
    }
    
    init() {
        self.restart()
    }
    
    func publishBroadcast(_ body: String, _ media: String?, _ mediaType: MediaType?) {
        self.broadcast = body
        if media != nil {
            
        }else {
            emit(Constants.Events.Broadcast, [
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines)
            ])
        }
    }
    
    func publishComment(_ body: String, _ broadcast: Broadcast, _ media: String?, _ mediaType: MediaType?) {
        self.comment = body
        if media != nil { }
        else {
            emit(Constants.Events.Comment, [
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines),
                "broadcast_id": broadcast.id!
            ])
        }
    }
    
    func joinBroadcast(_ broadcast: Broadcast) {
        emit(Constants.Events.JoinBroadcast, [
            "id": broadcast.id as Any
        ])
    }
    
    func fetchFeed() {
        let lastFeedCheck = UserDefaults.standard.string(forKey: Constants.lastFeedCheck)
        Socket.shared.emit(Constants.Events.Feed, [
            "lastFeedCheck": lastFeedCheck
        ])
    }
    
    enum MediaType: String {
        case photo, video, photos
    }
    
    func emit(_ event: String, _ data: [String: Any?]) {
        lastJob = {
            self.socket.emit(event, data)
        }
        self.lastJob?()
        if socket.status != .connected {
            print("Socket not connected! Retrying...")
        }
    }
    
    func start() {
        emit("ready", ["ready": true])
    }
}
