//
//  LiveTests.swift
//  LiveTests
//
//  Created by Anders Mannberg on 2020-05-11.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
@testable import TDD_Swift

class LiveTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRegisterRequest() {
        let e = expectation(description: "")
        var result: Result<String, API.Error>!
        
        Current.api.register { r in
            result = r
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        if case .failure(_) = result {
            XCTFail()
        }
    }
}
