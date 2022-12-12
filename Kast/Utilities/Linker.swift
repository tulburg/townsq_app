//
//  Linker.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 03/02/2021.
//

import UIKit

class Linker {
    
    var params: [String: Any]!
    var url: URL = URL(string: "http://127.0.0.1:3220/")!
    var host = "https://jsonplaceholder.typicode.com"
    var method = "POST"
    var image: UIImage!
    var completion: (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void?
    
    init (parameters: [String: Any], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        params = parameters
        self.completion = completion
    }
    
    init (parameters: [String: Any], image: UIImage, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        params = parameters
        self.image = image
        self.completion = completion
    }
    
    init (url: URL, parameters: [String: Any], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        params = parameters
        self.completion = completion
    }
    
    init (path: String, parameters: [String: Any], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = URL(string: "\(host)\(path)")!
        params = parameters
        self.completion = completion
    }
    
    init (path: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = URL(string: "\(host)\(path)")!
        method = "GET"
        self.completion = completion
    }
    
    init (url: URL, parameters: [String: Any], image: UIImage, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        self.url = url
        params = parameters
        self.image = image
        
        self.completion = completion
    }
    
    
    public func execute() {
        var request: URLRequest = URLRequest(url: url as URL)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: Constants.authToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }else {
            print("no token")
        }
        
        if params != nil {
            if let json = try? JSONSerialization.data(withJSONObject: params!) {
                //                print(String(data: json, encoding: .utf8))
                request.httpBody = json
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.completion(data ?? nil, response ?? nil, error)
            
            //            print("Got response from server: \(String(describing: response))")
            //
            //            let responseString = NSString(data: data ?? Data(), encoding: String.Encoding.utf8.rawValue)
            //            print("String response: \(responseString!)")
            
        }
        
        
        task.resume()
    }
    
}

struct Constants {
    static var authToken = "auth-token"
}
