//
//  AWSManager.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 19/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore

class S3 {
    
    private static let instance = {
        return S3()
    }()
    
    init() {
        let provider = AWSStaticCredentialsProvider(accessKey: "AKIA3IRYCDWJ3J6NADQM", secretKey: "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")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: provider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        AWSDDLog.sharedInstance.logLevel = .verbose
    }
    
    private let bucketName = "tq-imagecache-sn"
    
    func getName(name: String) -> String {
        return "https://tq-imagecache-sn.s3.amazonaws.com/\(name)"
    }
    
    func uploadImage(data: Data, name: String, completion: ((_ path: String) -> Void)?) {
        let request = AWSS3PutObjectRequest()
        request?.bucket = bucketName
        request?.acl = .publicRead
        request?.key = name
        request?.contentLength = data.count as NSNumber?
        request?.contentType = "image/jpeg"
        request?.body = data
        
        AWSS3.default().putObject(request!).continueWith(block: { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded")
                if completion != nil { completion!(self.getName(name: name)) }
            }
            return nil
        })
    }
    
    func uploadImage(path: String, name: String) -> String {
        let data = UIImage(contentsOfFile: path)?.jpegData(compressionQuality: 1)
        let request = AWSS3PutObjectRequest()
        request?.bucket = bucketName
        request?.acl = .publicRead
        request?.key = name
        request?.contentLength = data?.count as NSNumber?
        request?.contentType = "image/jpeg"
        request?.body = data
        
        AWSS3.default().putObject(request!).continueWith(block: { (task) -> Any? in
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Uploaded")
            }
            
            return nil
        })
        
        return "https://tq-imagecache-sn.s3.amazonaws.com/\(name)"
    }
    
    class func shared() -> S3 {
        return instance
    }
}
