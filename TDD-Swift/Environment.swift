//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

typealias RequestCallback<Value> = (Result<Value, API.Error>) -> Void
typealias Request<Value> = (RequestCallback<Value>) -> Void

var Current = Environment()

struct Environment {
    var api = API()
}

struct API {
    var login: Request<String> = { _ in

    }
}

extension API {
    enum Error: Swift.Error {
        case server
    }
}
