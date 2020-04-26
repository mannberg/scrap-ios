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
        Current = Environment()
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
        viewModel = .withCorrectCredentials
        XCTAssertTrue(viewModel.loginButtonEnabled)
    }
    
    func test_tapped_login_button_shows_spinner() {
        viewModel = .withCorrectCredentials
        viewModel.input(.didTapLoginButton)
        XCTAssertTrue(viewModel.isShowingLoadingSpinner)
    }
    
    func test_newly_instantiated_view_model_should_not_show_loading_spinner() {
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_should_not_be_able_to_tap_login_button_when_disabled() {
        viewModel.input(.didTapLoginButton)
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_hide_spinner_on_error() {
        let expectation = XCTestExpectation()
        
        viewModel = .withCorrectCredentials
        Current.api.login = { callback in
            callback(.failure(.server))
            
            XCTAssertFalse(self.viewModel.isShowingLoadingSpinner)
            expectation.fulfill()
        }
        
        viewModel.input(.didTapLoginButton)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_email_and_password_should_keep_values_on_error() {
        let expectation = XCTestExpectation()
        
        viewModel = .withCorrectCredentials
        let referenceViewModel = LoginPageViewModel.withCorrectCredentials
        
        Current.api.login = { callback in
            callback(.failure(.server))
            
            XCTAssertTrue(
                self.viewModel.email == referenceViewModel.email &&
                self.viewModel.password == referenceViewModel.password
            )
            expectation.fulfill()
        }
        
        viewModel.input(.didTapLoginButton)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_enabled_login_button_should_become_disabled_when_email_is_invalid() {
        viewModel = .withCorrectCredentials
        XCTAssertTrue(viewModel.loginButtonEnabled)
        viewModel.input(.didSetEmailAdress(""))
        XCTAssertFalse(viewModel.loginButtonEnabled)
    }
    
    func test_enabled_login_button_should_become_disabled_when_password_is_invalid() {
        viewModel = .withCorrectCredentials
        XCTAssertTrue(viewModel.loginButtonEnabled)
        viewModel.input(.didSetPassword(""))
        XCTAssertFalse(viewModel.loginButtonEnabled)
    }
    
    func test_viewModel_has_binding_helper() {
        let binding = self.viewModel.binding(
            get: \.email,
            toAction: { .didSetEmailAdress($0) }
        )
        let email = "joe@south.com"
        viewModel.input(.didSetEmailAdress(email))
        XCTAssertTrue(binding.wrappedValue == email)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

fileprivate extension LoginPageViewModel {
    static var withCorrectCredentials: LoginPageViewModel {
        let viewModel = LoginPageViewModel()
        viewModel.input(.didSetEmailAdress("joe@south.com"))
        viewModel.input(.didSetPassword("abcd1234"))
        return viewModel
    }
}
