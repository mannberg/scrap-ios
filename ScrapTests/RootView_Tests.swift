//
//  RootView_Tests.swift
//  ScrapTests
//
//  Created by Anders Mannberg on 2020-10-23.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import XCTest
import Combine
@testable import Scrap

class RootView_Tests: XCTestCase {
    
    func test_valid_token_returns_loggedIn_state() {
        let viewModel = RootViewModel(
            sideEffects: .init(
                hasToken: .init(true),
                clearToken: {},
                isFirstTimeLaunch: { fatalError() }
            )
        )
        
        XCTAssertEqual(viewModel.userState, .loggedIn)
    }
    
    func test_losing_token_should_change_userState_to_needsLogIn() {
        let hasTokenProvider = CurrentValueSubject<Bool, Never>(true)
        let viewModel = RootViewModel(
            sideEffects: .init(
                hasToken: hasTokenProvider,
                clearToken: {},
                isFirstTimeLaunch: { false }
            )
        )

        XCTAssertEqual(viewModel.userState, .loggedIn)
        
        hasTokenProvider.send(false)
        
        XCTAssertEqual(viewModel.userState, .needsToLogin)
    }
    
    func test_not_first_time_launch_without_token_should_set_userState_to_needsLogin() {
        let viewModel = RootViewModel(
            sideEffects: .init(
                hasToken: .init(false),
                clearToken: {},
                isFirstTimeLaunch: { false }
            )
        )
        
        XCTAssertEqual(viewModel.userState, .needsToLogin)
    }
    
    func test_first_time_launch_without_token_should_set_userState_to_needsRegister() {
        let viewModel = RootViewModel(
            sideEffects: .init(
                hasToken: .init(false),
                clearToken: {},
                isFirstTimeLaunch: { true }
            )
        )
        
        XCTAssertEqual(viewModel.userState, .needsToRegister)
    }
}
