//
//  RegisterPage_Tests.swift
//  TDD-SwiftTests
//
//  Created by Anders Mannberg on 2020-04-27.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
@testable import TDD_Swift

class RegisterPage_Tests: XCTestCase {
    var viewModel: RegisterPageViewModel!
    
    override func setUpWithError() throws {
        viewModel = RegisterPageViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_can_set_email_adress() {
        let value = "joe@south.com"
        viewModel.input(.setEmailAdress(value))
        XCTAssertTrue(viewModel.email == value)
    }
    
    func test_can_set_password() {
        let value: String = .validPassword
        viewModel.input(.setPassword(value))
        XCTAssertTrue(viewModel.password == value)
    }
    
    func test_can_set_confirmed_password() {
        let value: String = .validPassword
        viewModel.input(.setConfirmedPassword(value))
        XCTAssertTrue(viewModel.confirmedPassword == value)
    }
    
    func test_can_set_display_name() {
        let value = "Olle"
        viewModel.input(.setDisplayName(value))
        XCTAssertTrue(viewModel.displayName == value)
    }
    
    func test_empty_email_is_not_valid() {
        XCTAssertFalse(viewModel.isValidEmail)
    }
    
    func test_empty_password_is_not_valid() {
        XCTAssertFalse(viewModel.isValidPassword)
    }
    
    func test_empty_confirmed_password_is_not_valid() {
        XCTAssertFalse(viewModel.isValidConfirmedPassword)
    }
    
    func test_confirmed_password_is_not_valid_when_not_equal_to_valid_password() {
        viewModel.input(.setConfirmedPassword(.validPassword))
        XCTAssertFalse(viewModel.isValidConfirmedPassword)
    }
    
    func test_confirmed_password_is_only_valid_when_equal_to_valid_password() {
        let value: String = .validPassword
        viewModel.input(.setPassword(value))
        XCTAssertTrue(viewModel.isValidPassword)
        viewModel.input(.setConfirmedPassword(value))
        XCTAssertTrue(viewModel.isValidConfirmedPassword)
    }
    
    func test_empty_display_name_is_not_valid() {
        XCTAssertFalse(viewModel.isValidDisplayName)
    }
    
    func test_new_view_model_has_register_button_disabled() {
        XCTAssertFalse(viewModel.registerButtonEnabled)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}

fileprivate extension String {
    static var validPassword: String { "abcd1234" }
}
