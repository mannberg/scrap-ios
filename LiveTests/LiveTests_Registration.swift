//
//  LiveTests.swift
//  LiveTests
//
//  Created by Anders Mannberg on 2020-05-11.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
import Combine
import scrap_data_models
@testable import Scrap
@testable import Environment

class LiveTests_Registration: XCTestCase {

    var cancellable: AnyCancellable?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cancellable = nil
    }

    //MARK: Needs updated credentials to pass
    func testRegisterRequest_expectSuccess() {
        let e = expectation(description: "")
        var result: Subscribers.Completion<API.Error>!
        
        let user = UserRegistrationCandidate(
            displayName: "Joe",
            email: "joe@south.com",
            password: "abcd1234"
        )
        
        cancellable = Current.api.register(user).sink { r in
            result = r
            e.fulfill()
        } receiveValue: { _ in
            print("")
        }

        
        waitForExpectations(timeout: 1)
        
        switch result {
        case .finished:
            print("")
        case .failure(let error):
            XCTFail()
        case .none:
            print("")
        }
    }
    
    func testRegisterRequest_expectFailureDueToFaultyCredentials() {
        let e = expectation(description: "")
        var result: Subscribers.Completion<API.Error>!
        
        let user = UserRegistrationCandidate(
            displayName: "Joe",
            email: "joe@south.com",
            password: ""
        )
        
        cancellable = Current.api.register(user).sink { r in
            result = r
            e.fulfill()
        } receiveValue: { _ in
            
        }
        
        waitForExpectations(timeout: 1)
        
        guard case .failure(_) = result else {
            XCTFail()
            return
        }
    }
    
    func testLoginRequest_expectSuccess() {
        let e = expectation(description: "")
        
        let user = UserLoginCandidate(
            email: "joe@south.com",
            password: "abcd1234"
        )
        
        cancellable = Current.api.login(user).sink(receiveCompletion: { x in
            XCTFail()
        }, receiveValue: { v in
            e.fulfill()
        })
        
        waitForExpectations(timeout: 2)
    }
    
    //MARK: Should succeed with hardcoded DB token
    func testMeRequest_expectSuccess() {
        let e = expectation(description: "")
        var result: Subscribers.Completion<API.Error>!
        
        Current.token.tokenValue = { Token(value: "RMTZAHQn/a0U4gf/uSALLw==") }
        
        cancellable = Current.api.test().sink { r in
            result = r
            e.fulfill()
        } receiveValue: { _ in
            
        }

        waitForExpectations(timeout: 1)
        
        if case .failure(_) = result {
            //TODO: Fix error messages that suck!
            XCTFail()
        }
    }
}
