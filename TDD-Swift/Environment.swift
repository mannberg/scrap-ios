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

var Current = Environment()

struct Environment {
    var api = API()
}

struct API {
    var login: Request<String> = { _ in

    }
    
    var register: Request<String> = { callback in
        struct TestBody: Encodable {
            let id: String
        }
        
        let user = RegisterUser(
            displayName: "Joe",
            email: "joe@south.com",
            password: "abcd1234"
        )
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
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                callback(.failure(.server))
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            
            callback(.success(responseString!))
        }

        task.resume()
    }
}

extension API {
    enum Error: Swift.Error {
        case server
    }
}
