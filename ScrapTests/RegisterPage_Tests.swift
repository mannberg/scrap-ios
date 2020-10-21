//
//  RegisterPage_Tests.swift
//  TDD-SwiftTests
//
//  Created by Anders Mannberg on 2020-04-27.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
import Combine
@testable import Scrap
@testable import Environment

class RegisterPage_Tests: XCTestCase {
    var viewModel: RegisterPageViewModel!
    
    override func setUpWithError() throws {
        viewModel = RegisterPageViewModel()
        Current = .mock
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_can_set_email_adress() {
        let value = "joe@south.com"
        viewModel
            .input(.setEmailAdress(value))
            .thenAssertTrue(viewModel.email == value)
    }
    
    func test_can_set_password() {
        let value: String = .validPassword
        viewModel
            .input(.setPassword(value))
            .thenAssertTrue(viewModel.password == value)
    }
    
    func test_can_set_confirmed_password() {
        let value: String = .validPassword
        viewModel
            .input(.setConfirmedPassword(value))
            .thenAssertTrue(viewModel.confirmedPassword == value)
    }
    
    func test_can_set_display_name() {
        let value: String = .validDisplayName
        viewModel
            .input(.setDisplayName(value))
            .thenAssertTrue(viewModel.displayName == value)
    }
    
    func test_empty_email_is_not_valid() {
        viewModel.thenAssertFalse(\.isValidEmail)
    }
    
    func test_empty_password_is_not_valid() {
        viewModel.thenAssertFalse(\.isValidPassword)
    }
    
    func test_empty_confirmed_password_is_not_valid() {
        viewModel.thenAssertFalse(\.isValidConfirmedPassword)
    }
    
    func test_confirmed_password_is_not_valid_when_not_equal_to_valid_password() {
        viewModel
            .input(.setConfirmedPassword(.validPassword))
            .thenAssertFalse(\.isValidConfirmedPassword)
    }
    
    func test_confirmed_password_is_valid_when_equal_to_valid_password() {
        let value: String = .validPassword
        viewModel
            .input(.setPassword(value))
            .thenAssertTrue(\.isValidPassword)
            .input(.setConfirmedPassword(value))
            .thenAssertTrue(\.isValidConfirmedPassword)
    }
    
    func test_empty_display_name_is_not_valid() {
        viewModel.thenAssertFalse(\.isValidDisplayName)
    }
    
    func test_new_view_model_has_register_button_disabled() {
        viewModel.thenAssertFalse(\.registerButtonEnabled)
    }
    
    func test_valid_credentials_enables_register_button() {
        RegisterPageViewModel
            .withCorrectCredentials
            .thenAssertTrue(\.registerButtonEnabled)
    }
    
    func test_not_only_valid_display_name_enables_register_button() {
        viewModel
            .input(.setDisplayName(.validDisplayName))
            .thenAssertFalse(\.registerButtonEnabled)
    }
    
    func test_not_only_valid_email_enables_register_button() {
        viewModel
            .input(.setEmailAdress(.validEmail))
            .thenAssertFalse(\.registerButtonEnabled)
    }
    
    func test_not_only_valid_password_enables_register_button() {
        viewModel.input(
            .setPassword(.validPassword),
            .setConfirmedPassword(.validPassword)
        )
        .thenAssertFalse(\.registerButtonEnabled)
    }
    
    func test_changing_valid_credentials_disables_register_button() {
        RegisterPageViewModel
            .withCorrectCredentials
            .thenAssertTrue(\.registerButtonEnabled)
            .input(.setDisplayName(""))
            .thenAssertFalse(\.registerButtonEnabled)
            .input(.setDisplayName("Anders"))
            .thenAssertTrue(\.registerButtonEnabled)
    }
        
    func test_tapping_register_button_should_show_spinner() {
        Current.api.register = delayedSilentFailure()
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertTrue(\.isShowingLoadingSpinner)
    }
    
    func test_spinner_is_hidden_by_default() {
        viewModel.thenAssertFalse(\.isShowingLoadingSpinner)
    }
    
    func test_should_not_be_able_to_tap_register_button_when_disabled() {
        viewModel
            .input(.tapRegisterButton())
            .thenAssertFalse(\.isShowingLoadingSpinner)
    }
    
    func test_displays_error_message_when_not_nil() {
        viewModel = .withCorrectCredentials
        let errorMessage = "Stuff went wrong, my dude!"
        Current.api.register = visibleImmediateFailure(errorMessage: errorMessage)
        viewModel.input(.tapRegisterButton())
        
        guard let receivedMessage = viewModel.errorMessage else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(errorMessage, receivedMessage)
    }
    
    func test_error_message_is_nil_when_register_button_is_tapped() {
        viewModel = .withCorrectCredentials
        let errorMessage = "Stuff went wrong, my dude!"
        
        Current.api.register = visibleImmediateFailure(errorMessage: errorMessage)
        
        viewModel.input(.tapRegisterButton())
        
//        Current.api.register = { _ in Fail<Token, API.Error>(error: API.Error.silent)
//            .eraseToAnyPublisher() }
        viewModel.input(.tapRegisterButton())
        
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_spinner_is_hidden_on_server_error_with_message() {
        Current.api.register = visibleImmediateFailure(errorMessage: "")
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertFalse(\.isShowingLoadingSpinner)
    }
    
    func test_spinner_is_hidden_on_server_success() {
        Current.api.register = { _ in
            Just(Token(value: ""))
                .setFailureType(to: API.Error.self)
                .eraseToAnyPublisher()
        }
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertFalse(\.isShowingLoadingSpinner)
    }
    
    func test_register_button_is_disabled_during_request() {
        Current.api.register = delayedSilentFailure()
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertFalse(\.registerButtonEnabled)
    }
    
    func test_register_button_is_enabled_after_server_error() {
        Current.api.register = visibleImmediateFailure(errorMessage: "")
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertTrue(\.registerButtonEnabled)
    }
    
    func test_spinner_is_visible_during_request() {
        Current.api.register = delayedSilentFailure()
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertTrue(\.isShowingLoadingSpinner)
    }
    
    func test_textfields_are_disabled_during_request() {
        Current.api.register = delayedSilentFailure()
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertTrue(\.textFieldsAreDisabled)
    }
    
    func test_textfields_are_enabled_after_server_response() {
        Current.api.register = visibleImmediateFailure(errorMessage: "")
        
        RegisterPageViewModel
            .withCorrectCredentials
            .input(.tapRegisterButton())
            .thenAssertFalse(\.textFieldsAreDisabled)
    }
}

extension RegisterPageViewModel {
    @discardableResult
    func thenAssertFalse(_ keyPath: KeyPath<RegisterPageViewModel, Bool>) -> Self {
        XCTAssertFalse(self[keyPath: keyPath])
        return self
    }
    
    @discardableResult
    func thenAssertTrue(_ keyPath: KeyPath<RegisterPageViewModel, Bool>) -> Self {
        XCTAssertTrue(self[keyPath: keyPath])
        return self
    }
    
    @discardableResult
    func thenAssertTrue(_ predicate: @autoclosure () -> Bool) -> Self {
        XCTAssertTrue(predicate())
        return self
    }
}

//MARK: Helpers
fileprivate func visibleImmediateFailure(errorMessage: String) -> RegisterRequest {
    return { _ in
        Fail(error: API.Error.visible(message: errorMessage))
            .eraseToAnyPublisher()
    }
}

fileprivate func delayedSilentFailure() -> RegisterRequest {
    return { _ in
        Fail<Token, API.Error>(error: API.Error.silent)
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
