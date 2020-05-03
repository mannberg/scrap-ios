//
//  TDD_SwiftTests.swift
//  TDD-SwiftTests
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
@testable import TDD_Swift

class LoginPage_Tests: XCTestCase {
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
        viewModel.input(.tapLoginButton())
        XCTAssertTrue(viewModel.isShowingLoadingSpinner)
    }
    
    func test_newly_instantiated_view_model_should_not_show_loading_spinner() {
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_should_not_be_able_to_tap_login_button_when_disabled() {
        viewModel.input(.tapLoginButton())
        XCTAssertFalse(viewModel.isShowingLoadingSpinner)
    }
    
    func test_hide_spinner_on_error() {
        viewModel = .withCorrectCredentials
        
        viewModel.input(.tapLoginButton() { callback in
            XCTAssertTrue(self.viewModel.isShowingLoadingSpinner)
            callback(.failure(.server))
            XCTAssertFalse(self.viewModel.isShowingLoadingSpinner)
        })
    }
    
    func test_hide_spinner_on_success() {
        viewModel = .withCorrectCredentials
        
        viewModel.input(.tapLoginButton() { callback in
            XCTAssertTrue(self.viewModel.isShowingLoadingSpinner)
            callback(.success(""))
            XCTAssertFalse(self.viewModel.isShowingLoadingSpinner)
        })
    }
    
    func test_email_and_password_should_keep_values_on_error() {
        viewModel = .withCorrectCredentials
        let referenceViewModel = LoginPageViewModel.withCorrectCredentials
        
        viewModel.input(.tapLoginButton() { callback in
            callback(.failure(.server))
            
            XCTAssertTrue(
                self.viewModel.email == referenceViewModel.email &&
                self.viewModel.password == referenceViewModel.password
            )
        })
    }
    
    func test_enabled_login_button_should_become_disabled_when_email_is_invalid() {
        viewModel = .withCorrectCredentials
        XCTAssertTrue(viewModel.loginButtonEnabled)
        viewModel.input(.setEmailAdress(""))
        XCTAssertFalse(viewModel.loginButtonEnabled)
    }
    
    func test_enabled_login_button_should_become_disabled_when_password_is_invalid() {
        viewModel = .withCorrectCredentials
        XCTAssertTrue(viewModel.loginButtonEnabled)
        viewModel.input(.setPassword(""))
        XCTAssertFalse(viewModel.loginButtonEnabled)
    }
    
    func test_viewModel_has_binding_helper() {
        let binding = self.viewModel.binding(
            get: \.email,
            toAction: { .setEmailAdress($0) }
        )
        let email = "joe@south.com"
        viewModel.input(.setEmailAdress(email))
        XCTAssertTrue(binding.wrappedValue == email)
    }
    
    func test_register_button_tap_presents_register_page() {
        viewModel.input(.tapRegisterButton)
        XCTAssertTrue(viewModel.isPresentingRegisterPage)
    }
    
    func test_dismissing_register_page_makes_it_not_presenting() {
        viewModel.input(.tapRegisterButton)
        XCTAssertTrue(viewModel.isPresentingRegisterPage)
        viewModel.input(.dismissRegisterPage)
        XCTAssertFalse(viewModel.isPresentingRegisterPage)
    }
}

fileprivate extension LoginPageViewModel {
    static var withCorrectCredentials: LoginPageViewModel {
        let viewModel = LoginPageViewModel()
        viewModel.input(.setEmailAdress("joe@south.com"))
        viewModel.input(.setPassword("abcd1234"))
        return viewModel
    }
}
