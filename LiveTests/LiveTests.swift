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
        var result: Result<String, API.Error>!
        
        let user = RegisterUser(
            displayName: "Joe",
            email: "joe@south.com",
            password: "abcd1234"
        )
        
        Current.api.register(user) { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        if case .failure(_) = result {
            XCTFail()
        }
    }
    
    func testRegisterRequest_expectFailure() {
        let e = expectation(description: "")
        var result: Result<String, API.Error>!
        
        let user = RegisterUser(
            displayName: "Joe",
            email: "joe@south.com",
            password: ""
        )
        
        Current.api.register(user) { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        if
            case .failure(let error) = result,
            case .server(let message) = error
        {
            print(message)
        }
    }
}
