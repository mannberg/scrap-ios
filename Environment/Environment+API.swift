//
//  Environment+API.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-07-04.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import scrap_data_models

public typealias StatusCode = Int

public typealias RequestCallback<Value> = (Result<Value, API.Error>) -> Void
public typealias Request<Value> = (@escaping RequestCallback<Value>) -> Void

public typealias RegisterRequest = (UserRegistrationCandidate, @escaping RequestCallback<Token>) -> Void
public typealias LoginRequest = (UserLoginCandidate, @escaping RequestCallback<Token>) -> Void

public struct API {
    //MARK: Endpoints
    
    public var login: LoginRequest = { user, callback in
        let request = URLRequest
            .post(.login)
            .basicAuthorized(forUser: user)
        
        perform(
            request: request,
            responseTransform: { try? JSONDecoder().decode(Token.self, from: $0) },
            callback: { result in
                if case .success(let token) = result {
                    _ = Current.token.saveToken(token)
                } else {
                    callback(result)
                }
            }
        )
    }
    
    public var register: RegisterRequest = { user, callback in
        let request = URLRequest
            .post(.register)
            .with(data: try? JSONEncoder().encode(user))
        
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
    
    public var test: Request<String> = { callback in
        guard let request = URLRequest.get(.test).tokenAuthorized else {
            callback(.failure(.missingToken))
            return
        }
        
        perform(
            request: request,
            responseTransform: { String(data: $0, encoding: .utf8) },
            callback: callback
        )
    }
    
    //MARK: Private
    
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
                callback(.failure(.parse))
                return
            }
            
            callback(.success(res))
        }

        task.resume()
    }
}

public extension API {
    enum Error: Swift.Error {
        case connection
        case server(message: String? = nil)
        case visible(message: String)
        case silent
        case missingToken
        case parse
    }
}

public struct ServerError: Decodable {
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
        var request = URLRequest(url: url!).withDefaultHeaders
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

public struct Token: Codable, Equatable, CustomStringConvertible {
    
    public let value: String
    public var description: String { value }
    
    public init(value: String) {
        self.value = value
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

extension URLRequest {
    var tokenAuthorized: URLRequest? {
        guard let token = Current.token.tokenValue() else {
            return nil
        }
        
        var mutableSelf = self
        
        var headers = mutableSelf.allHTTPHeaderFields ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        mutableSelf.allHTTPHeaderFields = headers
        
        return mutableSelf
    }
    
    func basicAuthorized(forUser user: UserLoginCandidate) -> URLRequest {
        var mutableSelf = self
        
        var headers = mutableSelf.allHTTPHeaderFields ?? [:]
        headers["Authorization"] = "Basic \(user.basicAuthorizationFormatted)"
        mutableSelf.allHTTPHeaderFields = headers
        
        return mutableSelf
    }
    
    var withDefaultHeaders: URLRequest {
        var mutableSelf = self
        
        var headers = mutableSelf.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        mutableSelf.allHTTPHeaderFields = headers
        
        return mutableSelf
    }
    
    func with(data: Data?) -> URLRequest {
        var mutableSelf = self
        mutableSelf.httpBody = data
        
        return mutableSelf
    }
}

