//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import scrap_client_api

public var Current: Environment = .live

public struct Environment {
    public var api: API
}

extension Environment {
    static var live: Environment {
        Environment(
            api: API()
        )
    }
    
    static var mock: Environment {
        Environment(
            api: .mock
        )
    }
}
