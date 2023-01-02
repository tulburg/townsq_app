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
    
    let socket: SocketIOClient!
    var user: User!
    var lastJob: (() -> Void)? = nil
    var broadcast: String!
    
    static let shared: Socket = {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.makeSocket()
        return Socket(delegate.socket!)
    }()
    
    init(_ socket: SocketIOClient) {
        self.socket = socket
        user = DB.UserRecord()
        socket.on(clientEvent: .connect) { data, ack in
            let lastFeedCheck = UserDefaults.standard.string(forKey: Constants.lastFeedCheck)
            let activeBroadcasts = DB.activeBroadcasts()?.map{ $0.id }
            socket.emit("startup", [
                "lastFeedCheck": lastFeedCheck as Any ,
                "activeBroadcasts": activeBroadcasts as Any
            ])
            if let job = self.lastJob {
                job()
                self.lastJob = nil
            }
        }
        socket.on(clientEvent: .disconnect) { data, ack in
            
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
        }
        
        socket.on(Constants.Events.Feed) { data, ack in
            let response = Response<DataType.Feed>((data[0] as? NSDictionary)!)
            if response.code == 200 {
                if let data = response.data {
                    DB.insertFeed(data)
                }
            }
        }
        
        socket.onAny({ socket in
            print(socket)
        })
        
        socket.connect()
        
    }
    
    func publishBroadcast(_ body: String, _ media: String?, _ mediaType: MediaType?) {
        self.broadcast = body
        if media != nil {
            
        }else {
            emit("broadcast", [
                "body": body.trimmingCharacters(in: .whitespacesAndNewlines)
            ])
        }
    }
    
    func fetchFeed() {
        let lastFeedCheck = UserDefaults.standard.string(forKey: Constants.lastFeedCheck)
        Socket.shared.emit("feed", [
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
        if socket.status == .connected {
            self.lastJob?()
        }else {
            print("Socket not connected! Retrying...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.lastJob?()
                self.lastJob = nil
            })
        }
    }
    
    func start() {
        emit("ready", ["ready": true])
    }
}
