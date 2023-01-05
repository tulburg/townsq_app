//
//  Protocols.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 04/01/2023.
//  Copyright © 2023 Tolu Oluwagbemi. All rights reserved.
//

import Foundation

protocol SocketDelegate {
    func socket(didReceive event: Constants.Events, data: [Any])
}

extension SocketDelegate {
    func connect() {}
    func disconnect() {}
}
