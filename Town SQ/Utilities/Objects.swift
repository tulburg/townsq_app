//
//  Objects.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//
import Foundation

struct Response<T> {
    var code: Int?
    var status: Int?
    var message: String?
    var data: T?
    
    init(_ dict: NSDictionary) {
        if let code = dict["code"] as? Int { self.code = code }
        if let status = dict["status"] as? Int { self.status = status }
        if let message = dict["message"] as? String { self.message = message }
        if let data = dict["data"] as? T { self.data = data }
    }
    
//    func export() -> [String: String] {
//        return [
//            "max_occupancy" : String(describing: self.max_occupancy!), "price_per_hour" : String(describing: self.price_per_hour!),
//            "location" : self.location!, "description" : self.description!, "longitude" : String(describing: self.longitude!),
//            "latitude" : String(describing: self.latitude!), "meta" : meta!
//        ]
//    }
//
//    private mutating func metaData(_ meta: String) {
//        let ss: [Substring] = meta.split(separator: ",")
//        let tt: [Substring] = ss[0].split(separator: ":")
//        let vv: [Substring] = ss[1].split(separator: ":")
//        self.type = tt[1].description
//        self.size = Int(vv[1].description)
//    }
}


