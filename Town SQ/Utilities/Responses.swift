//
//  Objects.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//
import Foundation

class Response<T: ResponseData> {
    var code: Int?
    var status: Int?
    var message: String?
    var error: String?
    var data: T?
    
    init(_ dict: NSDictionary) {
        if let code = dict["code"] as? Int { self.code = code }
        if let status = dict["status"] as? Int { self.status = status }
        if let message = dict["message"] as? String { self.message = message }
        if T.self == DataType.None.self {
            if let data = dict["data"] as? String { self.data = T.init(data) }
        }else {
            if let data = dict["data"] as? NSDictionary { self.data = T.init(data) }
        }
        
        if let error = dict["error"] as? Int { self.error = Constants.ErrorMessages[error] }
    }
}

class DataType {
    class Broadcast: ResponseData {
        var created: Date?
        var id: String?
        var media: String?
        var media_type: MediaType?
        required init(_ dict: NSDictionary) {
            if let created = dict["created"] as? String { self.created = Date.from(string: created) }
            if let id = dict["id"] as? String { self.id = id }
            if let media = dict["media"] as? String { self.media = media }
            if let media_type = dict["media_type"] as? String { self.media_type = MediaType(rawValue: media_type) }
        }
    }
    
    class Startup: ResponseData {
        var activeBroadcasts: [BroadcastUpdate]?
        required init(_ dict: NSDictionary) {
            if let activeBroadcasts = dict["activeBroadcasts"] as? [NSDictionary] { self.activeBroadcasts = activeBroadcasts.map{ BroadcastUpdate($0) }
            }
        }
    }
    
    class BroadcastUpdate: ResponseData {
        var actives: Int?
        var comments: [NewComment]?
        var id: String?
        required init(_ dict: NSDictionary) {
            if let actives = dict["actives"] as? Int { self.actives = actives }
            if let comments = dict["comments"] as? [NSDictionary] {
                self.comments = comments.map{ NewComment($0) }
            }
            if let id = dict["id"] as? String { self.id = id }
        }
    }
    
    class Comment: ResponseData {
        var created: Date?
        var id: String?
        var broadcast_id: String?
        required init(_ dict: NSDictionary) {
            if let created = dict["created"] as? String { self.created = Date.from(string: created) }
            if let id = dict["id"] as? String { self.id = id }
            if let broadcast_id = dict["broadcast_id"] as? String { self.broadcast_id = broadcast_id }
        }
    }
    
    class NewBroadcast: ResponseData {
        var id: String?
        var created: Date?
        required init(_ dict: NSDictionary) {
            if let id = dict["id"] as? String { self.id = id }
            if let created = dict["created"] as? String { self.created = Date.from(string: created) }
        }
    }
    
    class NewComment: ResponseData {
        var body: String?
        var created: Date?
        var id: String?
        var broadcast_id: String?
        var user: User?
        required init(_ dict: NSDictionary) {
            if let body = dict["body"] as? String { self.body = body }
            if let created = dict["created"] as? String { self.created = Date.from(string: created) }
            if let id = dict["id"] as? String { self.id = id }
            if let broadcast_id = dict["broadcast_id"] as? String { self.broadcast_id = broadcast_id }
            if let user = dict["user"] as? NSDictionary { self.user = User(user) }
        }
    }
    
    class NewVote: ResponseData {
        var vote: Int?
        var id: String?
        required init(_ dict: NSDictionary) {
            if let id = dict["id"] as? String { self.id = id }
            if let vote = dict["vote"] as? Int { self.vote = vote }
        }
    }
    
    class Feed: ResponseData {
        class Broadcast {
            var body: String?
            var created: Date?
            var id: String?
            var user: User?
            init(_ dict: NSDictionary) {
                if let body = dict["body"] as? String { self.body = body }
                if let created = dict["created"] as? String { self.created = Date.from(string: created) }
                if let id = dict["id"] as? String { self.id = id }
                if let user = dict["user"] as? NSDictionary { self.user = User(user) }
            }
        }
        var broadcasts: [Broadcast]?
        required init(_ dict: NSDictionary) {
            if let broadcasts = dict["broadcasts"] as? [NSDictionary] {
                self.broadcasts = broadcasts.map({ item in
                    return Broadcast(item)
                })
            }
        }
    }
    class User {
        var id: String?
        var name: String?
        var profile_photo: String?
        var username: String?
        init(_ dict: NSDictionary) {
            if let name = dict["name"] as? String { self.name = name }
            if let profile_photo = dict["profile_photo"] as? String { self.profile_photo = profile_photo }
            if let username = dict["username"] as? String { self.username = username }
            if let id = dict["id"] as? String { self.id = id }
        }
    }
    
    class None: ResponseData {
        var value: String?
        required init(_ value: String) {
            self.value = value
        }
    }
}

@objc protocol ResponseData {
    init(_ dict: NSDictionary)
    init(_ value: String)
}


