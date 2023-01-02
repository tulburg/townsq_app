//
//  Constants.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation

struct Constants {
    static let ErrorMessages = [
        1001: "Phone number already used, please try again with a different phone number",
        1002: "Server error, unable to send verification code",
        1003: "Verfification code is invalid, please try again",
        1004: "Phone number is not registered",
        1005: "Invite code is invalid, please try again",
        1006: "Unauthorized",
        1008: "Username is already taken"
    ]
    static let Messages = [
        1001: "Verification code sent!",
        1002: "Verification successful!",
        1003: "Invite code successful"
    ]
    
    struct Events {
        static let Broadcast = "broadcast"
        static let Feed = "feed"
    }
    
    static let Base = "http://192.168.18.3:5400"
    
    static let authToken = "auth-token"
    static let defaultMessageDelay: CGFloat = 8
    static let progress = "progress"
    static let inviteCode = "invite-code"
    static let startupProgress = "startup-progress"
    static let verificationPhone = "verification-phone"
    static let verificationCountry = "verification-country"
    static let S3Addr = "https://tq-imagecache-sn.s3.amazonaws.com/"
    static let lastFeedCheck = "last-feed-check"
}
