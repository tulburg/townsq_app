//
//  Api.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class Api {
    
    static let main = {
        return Api(base: Constants.Base)
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
    
    func verifyCode(_ code: String, _ phone: String, _ inviteCode: String?, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/verify-code"
        self.completion = completion
        parameters = ["code": "\(code)", "phone": "\(phone)", "invite": "\(inviteCode!)"]
        execute(.POST)
    }
    
    func verifyPhone(_ phone: String, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/verify-phone"
        parameters = ["phone": phone.trimmingCharacters(in: .whitespaces)]
        self.completion = completion
        execute(.POST)
    }
    
    func verifyInviteCode(_ code: String, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/invite-code?code=\(code)"
        parameters = nil
        self.completion = completion
        execute(.GET)
    }
    
    func setProfile(_ title: String, _ value: String, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/profile"
        parameters = ["data": [title : value]]
        self.completion = completion
        execute(.POST)
    }
    
    func verifyUsername(_ username: String, completion: ((_ data: Data?, _ error: Error?) -> Void)?) {
        path = "/username?username=\(username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        parameters = nil
        self.completion = completion
        execute(.GET)
    }
    
    private func execute(_ method: Method) {
        var request: URLRequest = URLRequest(url: URL(string: (base + path))!)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "did")
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
