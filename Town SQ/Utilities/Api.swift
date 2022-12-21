//
//  Api.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation

class Api {
    
    static let main = {
        return Api(base: "http://192.168.18.3:5400")
    }()
    
    private var parameters: [String: Any]?
    private var completion: ((_ data: Data?, _ error: Error?) -> Void)?
    private var path: String!
    private var base: String!
    
    init(base: String) {
        self.base = base
        path = "/"
        completion = nil
        parameters = nil
    }
    
    func verifyInviteCode(_ code: String, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/user/invite-code?code=\(code)"
        self.completion = completion
        execute(.GET)
    }
    
    private func execute(_ method: Method) {
        var request: URLRequest = URLRequest(url: URL(string: (base + path))!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: Constants.authToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if parameters != nil {
            if let json = try? JSONSerialization.data(withJSONObject: parameters!) {
                request.httpBody = json
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if self.completion != nil { self.completion!(data ?? nil, error)  }
        }
        task.resume()
    }
    
    class func shared() -> Api {
        return main
    }
    
    enum Method: String {
        case POST
        case GET
        case DELETE
    }
}
