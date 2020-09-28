//
//  Environment+Token.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-07-30.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import Security

//TODO: TokenHandler should be an enum... Or should it...?
//TODO: It should definitively be it's own package.
public struct TokenHandler {
    //TODO: Check if this is a good name...
    let tokenKey = "AuthorizationToken"
    
    //TODO: Write test that verifies new server token is always saved when retrieved.
    public var saveToken: (Token) -> Result<Void, API.Error> = { token in
        guard let tokenData = token.value.data(using: .utf8) else {
            //TODO: Notify server if token changes format
            //TODO: Write test that verifies our token structure does not change.
            return .failure(.parse)
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: Current.token.tokenKey,
            kSecValueData as String: tokenData
        ] as [String: Any]
                
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        //TODO: Failure should be logged to the server + the user should be notified
        return status == noErr ? .success(()) : .failure(.silent)
    }
    
    public var loadToken: () -> Result<Token, API.Error> = {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: Current.token.tokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard
            status == noErr,
            let data = dataTypeRef as? Data,
            let tokenAsString = String(data: data, encoding: .utf8)
        else {
            return .failure(.silent)
        }
        
        return .success(Token(value: tokenAsString))
    }
    
    public var clearToken: () -> Void = {
        let spec: NSDictionary = [kSecClass: kSecClassGenericPassword]
        SecItemDelete(spec)
    }
    
    public var tokenValue: () -> Token? = {
        if case .success(let token) = Current.token.loadToken() {
            return token
        } else {
            return nil
        }
    }
}

extension TokenHandler {
    static var mock: TokenHandler {
        TokenHandler(
            saveToken: { _ in .success(()) },
            tokenValue: { nil }
        )
    }
}
