//
//  Token_tests.swift
//  ScrapTests
//
//  Created by Anders Mannberg on 2020-07-30.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
@testable import Scrap
@testable import Environment

class Token_tests: XCTestCase {

    override func setUpWithError() throws {
        Current = .mock
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_token_key_does_not_change() throws {
        XCTAssertEqual(Current.token.tokenKey, "AuthorizationToken")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
