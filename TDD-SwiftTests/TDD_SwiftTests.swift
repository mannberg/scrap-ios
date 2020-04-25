//
//  TDD_SwiftTests.swift
//  TDD-SwiftTests
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
@testable import TDD_Swift

class TDD_SwiftTests: XCTestCase {
    var viewModel: LoginPageViewModel!
    
    override func setUpWithError() throws {
        viewModel = LoginPageViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_empty_email_and_password_fields_gives_disabled_login_button() {
        XCTAssertFalse(viewModel.loginButtonEnabled)
    }
    
    func test_newly_instantiated_view_model_should_have_empty_email_and_password_fields() {
        XCTAssertTrue(viewModel.email.isEmpty)
        XCTAssertTrue(viewModel.password.isEmpty)
    }
    
    func test_valid_email_and_password_gives_enabled_login_buton() {
        viewModel.email = "joe@south.com"
        viewModel.password = "abcd1234"
        XCTAssertTrue(viewModel.loginButtonEnabled)
    }
    
    func test_tapped_login_button_shows_spinner() {
        viewModel.didTapLoginButton()
        XCTAssertTrue(viewModel.isShowingLoadingSpinner)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
