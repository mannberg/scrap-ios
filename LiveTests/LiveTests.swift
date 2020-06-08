//
//  LiveTests.swift
//  LiveTests
//
//  Created by Anders Mannberg on 2020-05-11.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
import scrap_data_models
@testable import Scrap

class LiveTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegisterRequest_expectSuccess() {
        let e = expectation(description: "")
        var result: Result<Token, API.Error>!
        
        let user = UserRegistrationCandidate(
            displayName: "Joe",
            email: "joe@south.com",
            password: "abcd1234"
        )
        
        Current.api.register(user) { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
//        if case .failure(_) = result {
//            XCTFail()
//        }
        
//        guard case .failure(let error) = result else {
//            XCTFail()
//            return
//        }
    }
    
    func testRegisterRequest_expectFailureDueToFaultyCredentials() {
        let e = expectation(description: "")
        var result: Result<Token, API.Error>!
        
        let user = UserRegistrationCandidate(
            displayName: "Joe",
            email: "joe@south.com",
            password: ""
        )
        
        Current.api.register(user) { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        guard case .failure(let error) = result else {
            XCTFail()
            return
        }
        
        print("")
    }
    
    func testLoginRequest_expectSuccess() {
        let e = expectation(description: "")
        var result: Result<Token, API.Error>!
        
        let user = UserLoginCandidate(
            email: "joe@south.com",
            password: "abcd1234"
        )
        
        Current.api.login(user) { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        if case .failure(let error) = result {
            //TODO: Fix error messages that suck!
            XCTFail()
        }
    }
    
    func testMeRequest_expectSuccess() {
        let e = expectation(description: "")
        var result: Result<String, API.Error>!
        
        Current.api.test { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        if case .failure(let error) = result {
            //TODO: Fix error messages that suck!
            XCTFail()
        }
    }
}
