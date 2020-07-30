//
//  LiveTests+Token.swift
//  LiveTests
//
//  Created by Anders Mannberg on 2020-08-08.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
import Environment

class LiveTests_Token: XCTestCase {
    
    func testCanSaveAndLoadToken() throws {
        let tokenToSave = Token(value: "bhAIuuJDLOeiNuAHHhwHHA==")
        
        if case .failure(_) = Current.token.saveToken(tokenToSave) {
            XCTFail()
        }
        
        let result = Current.token.loadToken()
        
        switch result {
        case .success(let loadedToken):
            XCTAssertEqual(loadedToken, tokenToSave)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testCanDeleteToken() throws {
        let tokenToSave = Token(value: "bhAIuuJDLOeiNuAHHhwHHA==")
        
        if case .failure(_) = Current.token.saveToken(tokenToSave) {
            XCTFail()
        }
        
        Current.token.clearToken()
        
        let result = Current.token.loadToken()
        
        if case .success(_) = result {
            XCTFail()
        }
    }
}
