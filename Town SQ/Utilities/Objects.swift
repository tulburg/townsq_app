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
        if let data = dict["data"] as? NSDictionary { self.data = T.init(data) }
        if let error = dict["error"] as? Int { self.error = Constants.ErrorMessages[error] }
    }
}

class DataType {
    class Broadcast: ResponseData {
        var created: Date?
        var id: String?
        required init(_ dict: NSDictionary) {
            if let created = dict["created"] as? String { self.created = Date.from(string: created) }
            if let id = dict["id"] as? String { self.id = id }
        }
    }
    
    class None: ResponseData {
        required init(_ dict: NSDictionary) {
            
        }
    }
}

protocol ResponseData {
    init(_ dict: NSDictionary)
}


