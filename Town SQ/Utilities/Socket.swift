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
    var delegates: [SocketDelegate] = []
    
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
            let activeBroadcasts = DB.activeBroadcasts()?.map{ item in
                let broadcast = item as Broadcast
                let lastCheck = broadcast.last_check
                return ["id": broadcast.id as Any, "last_check": lastCheck?.toString() as Any]
            }
            self.socket.emit("startup", [
                "lastFeedCheck": lastFeedCheck as Any ,
                "activeBroadcasts": activeBroadcasts as Any
            ])
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            
        }
        
        socket.on(Constants.Events.Startup.rawValue) { data, ack in
            self.socket.emit(Constants.Events.Startup.receipt())
            if let job = self.lastJob {
                job()
                self.lastJob = nil
            }
            var totalComment = 0
            let response = Response<DataType.Startup>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                UserDefaults.standard.set(Date().milliseconds, forKey: Constants.lastFeedCheck)
                response.data?.activeBroadcasts?.forEach{ item in
                    let broadcasts = DB.shared.find(.Broadcast, predicate: NSPredicate(format: "id = %@", item.id!))
                    if broadcasts.count > 0 {
                        let broadcast: Broadcast = (broadcasts[0] as? Broadcast)!
                        broadcast.people = Int16(item.actives!)
                        broadcast.last_check = Date()
                        totalComment = totalComment + item.comments!.count
                        item.comments?.forEach({ comment in
                            let index = broadcast.comments?.array.firstIndex(where: { oldComment in
                                return (oldComment as? Comment)?.id == comment.id
                            })
                            if index == nil {
                                let newComment = Comment(context: DB.shared.context)
                                newComment.id = comment.id
                                newComment.body = comment.body
                                newComment.created = comment.created
                                
                                var user = DB.shared.findById(.User, id: (comment.user?.id)!) as? User
                                if user == nil {
                                    user = User(context: DB.shared.context)
                                    user?.id = comment.user?.id
                                    user?.profile_photo = comment.user?.profile_photo
                                    user?.name = comment.user?.name
                                    user?.username = comment.user?.username
                                }
                                newComment.user = user
                                newComment.broadcast = broadcast
                            }
                        })
                        if totalComment > 0 {
                            self.delegates.forEach{ $0.socket(didReceive: .GotComment, data: response.data!)}
                        }
                        DB.shared.save()
                    }
                }
            }
        }
        
        socket.on(Constants.Events.Broadcast.rawValue) { data, ack in
            self.socket.emit(Constants.Events.Broadcast.receipt())
            let response = Response<DataType.Broadcast>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                var param = [
                    "user": self.user as Any,
                    "body": self.broadcast as Any,
                    "created": response.data?.created as Any,
                    "id": response.data?.id as Any,
                    "active": BroadcastType.Active.rawValue,
                    "joined": Date()
                ];
                if response.data?.media_type != nil && response.data?.media != nil {
                    param["media"] = response.data?.media
                    param["media_type"] = response.data?.media_type?.rawValue
                }
                print("inserting... >>> ", param)
                DB.shared.insert(.Broadcast, keyValue: param)
                self.delegates.forEach{ $0.socket(didReceive: .GotBroadcast, data: response.data!)}
            }
            self.lastJob = nil
        }
        
        socket.on(Constants.Events.Comment.rawValue) { data, ack in
            self.socket.emit(Constants.Events.Comment.receipt())
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
        
        // MARK:  - Got Events from server
        
        socket.on(Constants.Events.GotBroadcast.rawValue) { data, ack in
            self.socket.emit(Constants.Events.GotBroadcast.receipt())
            let response = Response<DataType.NewBroadcast>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                let broadcasts = DB.shared.findById(.Broadcast, id: (response.data?.id)!)
            }
        }
        
        socket.on(Constants.Events.GotComment.rawValue) { data, ack in
            self.socket.emit(Constants.Events.GotComment.receipt())
            let response = Response<DataType.NewComment>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                let broadcasts = DB.shared.find(.Broadcast, predicate: NSPredicate(format: "id = %@", (response.data?.broadcast_id)!))
                if broadcasts.count > 0 {
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
                    (broadcasts[0] as! Broadcast).unread = (broadcasts[0] as! Broadcast).unread + 1
                    DB.shared.save()
                }
                self.delegates.forEach{ $0.socket(didReceive: .GotComment, data: response.data!)}
            }
        }
        
        socket.on(Constants.Events.GotUser.rawValue) { data, ack in
            self.socket.emit(Constants.Events.GotUser.receipt())
            let response = Response<DataType.BroadcastUpdate>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                if let broadcast: Broadcast = DB.shared.findById(.Broadcast, id: (response.data?.id)!) as? Broadcast {
                    broadcast.people = Int16((response.data?.actives)!)
                    DB.shared.save()
                    self.delegates.forEach{ $0.socket(didReceive: .GotUser, data: response.data!)}
                }
            }
        }
        
        socket.on(Constants.Events.GotVote.rawValue) { data, ack in
            self.socket.emit(Constants.Events.GotVote.receipt())
            let response = Response<DataType.NewVote>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                if let comment: Comment = DB.shared.findById(.Comment, id: (response.data?.id)!) as? Comment {
                    comment.vote = comment.vote + Int16((response.data?.vote)!)
                    DB.shared.save()
                    self.delegates.forEach{ $0.socket(didReceive: .GotVote, data: response.data!)}
                }
            }
        }
        
        socket.on(Constants.Events.Feed.rawValue) { data, ack in
            self.socket.emit(Constants.Events.Feed.receipt())
            let response = Response<DataType.Feed>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                if let data = response.data {
                    DB.insertFeed(data)
                }
                self.delegates.forEach{ $0.socket(didReceive: .GotFeed, data: response.data!)}
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
    
    // MARK: - Publish fuctions
    
    func publishBroadcast(_ body: String, _ media: String?, _ mediaType: MediaType?) {
        self.broadcast = body
        guard
            body.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        else { return }
        if media != nil {
            emit(Constants.Events.Broadcast.rawValue,  [
                "media": media, "media_type": mediaType?.rawValue,
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines)
            ])
        }else {
            emit(Constants.Events.Broadcast.rawValue, [
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines)
            ])
        }
    }
    
    func publishComment(_ body: String, _ broadcast: Broadcast, _ media: String?, _ mediaType: MediaType?) {
        self.comment = body
        if media != nil { }
        else {
            emit(Constants.Events.Comment.rawValue, [
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines),
                "broadcast_id": broadcast.id!
            ])
        }
    }
    
    func publishVote(_ comment: Comment, _ vote: Int) {
        emit(Constants.Events.CommentVote.rawValue, [
            "id": comment.id,
            "vote": vote
        ])
    }
    
    func joinBroadcast(_ broadcast: Broadcast) {
        emit(Constants.Events.JoinBroadcast.rawValue, [
            "id": broadcast.id as Any
        ])
    }
    
    func fetchFeed() {
        let lastFeedCheck = UserDefaults.standard.string(forKey: Constants.lastFeedCheck)
        Socket.shared.emit(Constants.Events.Feed.rawValue, [
            "lastFeedCheck": lastFeedCheck
        ])
    }
    
    func markUnread(_ broadcast: Broadcast) {
        broadcast.unread = 0
        DB.shared.save()
        delegates.forEach{ $0.socket(didMarkUnread: broadcast) }
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
    
    func registerDelegate(_ delegate: SocketDelegate) {
        delegates.append(delegate)
    }
    
    func unregisterDelegate(_ delegate: SocketDelegate) {
        delegates.removeAll(where: { return $0 === delegate })
    }
}

enum MediaType: String {
    case photo, video, photos
}
