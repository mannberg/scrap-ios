//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

var Current = Environment()

struct Environment {
    var api = API()
}

struct API {
    var login: ((Result<String, API.Error>) -> Void) -> Void = { _ in
        
    }
}

extension API {
    enum Error: Swift.Error {
        case server
    }
}
