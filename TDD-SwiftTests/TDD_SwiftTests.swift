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
        CurrentAPI = API()
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
        viewModel.didTapLoginButton()
        XCTAssertTrue(viewModel.isShowingLoadingSpinner)
    }
    
    func test_newly_instantiated_view_model_should_not_show_loading_spinner() {
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_should_not_be_able_to_tap_login_button_when_disabled() {
        viewModel.didTapLoginButton()
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_hide_spinner_on_server_error() {
        let expectation = XCTestExpectation()
        
        viewModel = .withCorrectCredentials
        CurrentAPI.login = { callback in
            callback(.failure(.server))
            XCTAssertFalse(self.viewModel.isShowingLoadingSpinner)
            expectation.fulfill()
        }
        
        viewModel.didTapLoginButton()
        wait(for: [expectation], timeout: 0.1)
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
        viewModel.didSetEmailAdress("joe@south.com")
        viewModel.didSetPassword("abcd1234")
        return viewModel
    }
}
