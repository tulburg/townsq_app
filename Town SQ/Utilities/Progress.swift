//
//  Progress.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 28/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import Foundation

class Progress {
    public static var state: ProgressState? {
        get {
            let current = UserDefaults.standard.integer(forKey: Constants.progress)
            return ProgressState(rawValue: current)
        }
        set {
            UserDefaults.standard.set(newValue!.rawValue, forKey: Constants.progress)
        }
    }
    
    enum ProgressType: String {
        case Startup, Message, Post
    }
    enum ProgressState: Int {
        case None, InviteCodeVerified, PhoneCodeSent, PhoneVerified, DisplayNameSet,
        UsernameSet, DOBSet, ProfilePhotoSet
    }

}
