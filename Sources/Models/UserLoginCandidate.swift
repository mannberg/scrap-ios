//
//  LoginCandidate.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-06-07.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

public struct UserLoginCandidate {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var basicAuthorizationFormatted: String {
        Data("\(email):\(password)".utf8).base64EncodedString()
    }
}
