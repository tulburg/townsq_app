//
//  Message.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 27/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import Foundation

struct Message {
	
	var id: Int?
	var body: String?
	var date: String?
	var location: String?
	var sender: String?
	
	init(_ data: NSDictionary) {
		if let id = data["id"] as? Int { self.id = id }
		if let body = data["body"] as? String { self.body = body }
		if let date = data["date"] as? String { self.date = date }
		if let sender = data["sender"] as? String { self.sender = sender }
//		if let location = data["location"] as? String { self.location = location }
	}
}
