//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

public var Current: Environment = .live

public struct Environment {
    public var api: API
    public var token: TokenHandler
}

extension Environment {
    static var live: Environment {
        Environment(
            api: API(),
            token: TokenHandler()
        )
    }
    
    static var mock: Environment {
        Environment(
            api: .mock,
            token: .mock
        )
    }
}
