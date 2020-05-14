//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import scrap_data_models

typealias RequestCallback<Value> = (Result<Value, API.Error>) -> Void
typealias Request<Value> = (@escaping RequestCallback<Value>) -> Void

typealias RegisterRequest = (RegisterUser, @escaping RequestCallback<String>) -> Void
typealias LoginRequest = Request<String>

var Current: Environment = .live

struct Environment {
    var api: API
}

extension Environment {
    static var live: Environment {
        Environment(api: API())
    }
    
    static var mock: Environment {
        Environment(api: .mock)
    }
}

extension API {
    static var mock: API {
        API(
            login: { _ in },
            register: { _, _ in }
        )
    }
}

struct API {
    var login: Request<String> = { _ in

    }
    
    var register: RegisterRequest = { user, callback in
        let url = URL(string: "http://localhost:8080/register")
        let data = try? JSONEncoder().encode(user)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = data
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                callback(.failure(.connection))
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                let error = try? JSONDecoder().decode(ServerError.self, from: data)
                callback(.failure(.server(message: error?.reason)))
                return
            }

            guard let responseString = String(data: data, encoding: .utf8) else {
                //How to handle this? Corrupt data...
                return
            }
            callback(.success(responseString))
        }

        task.resume()
    }
}

extension API {
    enum Error: Swift.Error {
        case connection
        case server(message: String? = nil)
    }
}

struct ServerError: Decodable {
    let reason: String
}
