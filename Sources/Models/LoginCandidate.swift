//
//  LoginCandidate.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-06-07.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

struct UserLoginCandidate {
    let email: String
    let password: String
    
    var basicAuthorizationFormatted: String {
        Data("\(email):\(password)".utf8).base64EncodedString()
    }
}
