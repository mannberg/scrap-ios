//
//  APIError+Extensions.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-10-23.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import scrap_client_api

extension API.Error {
    func toString(_ errorMap: Self.Dictionary = .init()) -> String? {
        switch self {
        case .couldNotStoreToken:
            return errorMap.couldNotStoreToken
        case .missingToken:
            return errorMap.missingToken
        case .noNetwork:
            return errorMap.noNetwork
        case .parse:
            return errorMap.parse
        case .server(let message):
            return message
        case .serverUnreachable:
            return errorMap.serverUnreachable
        case .silent:
            return errorMap.silent
        case .unspecifiedURLError:
            return errorMap.unspecifiedURLError
        }
    }
    
    struct Dictionary {
        let couldNotStoreToken: String? = nil
        let missingToken: String? = nil
        let noNetwork: String? = "Please check your internet connection."
        let parse: String? = nil
        let serverUnreachable: String? = "We're having trouble reaching our server at the moment. Please try again later."
        let silent: String? = nil
        let unspecifiedURLError: String? = "Something went wrong, please try again later."
    }
}
