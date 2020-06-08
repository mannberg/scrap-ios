//
//  Environment.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import scrap_data_models

typealias StatusCode = Int

typealias RequestCallback<Value> = (Result<Value, API.Error>) -> Void
typealias Request<Value> = (@escaping RequestCallback<Value>) -> Void

typealias RegisterRequest = (UserRegistrationCandidate, @escaping RequestCallback<Token>) -> Void
typealias LoginRequest = (UserLoginCandidate, @escaping RequestCallback<Token>) -> Void

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
            login: { _, _ in },
            register: { _, _ in }
        )
    }
}

struct API {
    var login: LoginRequest = { user, callback in
        var request: URLRequest = .post(.login)
        
        var headers = Headers.defaultHeader(forRequest: request)
        headers["Authorization"] = "Basic \(user.basicAuthorizationFormatted)"
        request.allHTTPHeaderFields = headers
        
        perform(
            request: request,
            responseTransform: { return try? JSONDecoder().decode(Token.self, from: $0) },
            callback: callback
        )
    }
    
    var register: RegisterRequest = { user, callback in
        var request: URLRequest = .post(.register)
        
        let data = try? JSONEncoder().encode(user)
        request.httpBody = data
        
        var headers = Headers.defaultHeader(forRequest: request)
        
        request.allHTTPHeaderFields = headers
        
        perform(
            request: request,
            responseTransform: { return try? JSONDecoder().decode(Token.self, from: $0) },
            errorTransform: { data, statusCode in
                guard
                    [400, 409].map { $0 == statusCode }.contains(true),
                    let serverError = try? JSONDecoder().decode(ServerError.self, from: data)
                else {
                    return .visible(message: "Some generic error title")
                }
                
                return .visible(message: serverError.reason)
            },
            callback: callback
        )
    }
    
    var test: Request<String> = { callback in
        
        var request: URLRequest = .get(.test)
        var headers = Headers.defaultHeader(forRequest: request)
        headers["Authorization"] = "Bearer bhAIuuJDLOeiNuAHHhwHHA=="
        request.allHTTPHeaderFields = headers
        
        perform(
            request: request,
            responseTransform: { String(data: $0, encoding: .utf8) },
            callback: callback
        )
    }
    
    private static func perform<ReturnValue>(
        request: URLRequest,
        responseTransform: @escaping (Data) -> ReturnValue?,
        errorTransform: @escaping (Data, StatusCode) -> API.Error = { _, _ in .silent },
        callback: @escaping RequestCallback<ReturnValue>) {
        
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
                callback(.failure(errorTransform(data, response.statusCode)))
                return
            }

            guard let res = responseTransform(data) else {
                //How to handle this? Corrupt data...
                return
            }
            callback(.success(res))
        }

        task.resume()
    }
}

extension API {
    enum Error: Swift.Error {
        case connection
        case server(message: String? = nil)
        case visible(message: String)
        case silent
    }
}

struct ServerError: Decodable {
    let reason: String
}

extension URLRequest {
    static func post(_ endpoint: PostEndpoint) -> URLRequest {
        let base = "http://localhost:8080"
        let urlString: String
        
        switch endpoint {
        case .register:
            urlString = "\(base)/register"
        case .login:
            urlString = "\(base)/login"
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        return request
    }
    
    static func get(_ endpoint: GetEndpoint) -> URLRequest {
        let base = "http://localhost:8080"
        let urlString: String
        
        switch endpoint {
        case .test:
            urlString = "\(base)/me"
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        return request
    }
}

enum PostEndpoint {
    case login
    case register
}

enum GetEndpoint {
    case test
}

struct Token: Codable {
    let value: String
}

typealias Headers = [String: String]

fileprivate extension Dictionary where Key == String, Value == String {
    static func defaultHeader(forRequest request: URLRequest) -> [String : String] {
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        return headers
    }
}
