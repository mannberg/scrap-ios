//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine
import IsValid
import scrap_client_api

class LoginPageViewModel: ObservableObject, ViewModel {
    
    init(
        userState: Binding<RootViewModel.UserState>,
        sideEffects: SideEffects = .live
    ) {
        self.userState = userState
        self.sideEffects = sideEffects
    }
    
    var sideEffects: SideEffects
    
    func input(_ action: LoginPageViewModel.Action) {
        switch action {
        case .tapLoginButton:
            guard loginButtonEnabled else {
                return
            }
            
            isShowingLoadingSpinner = true
            registerButtonEnabled = false
            
            loginRequestCancellable = sideEffects.login(userToLogin).sink { [weak self] completion in
                self?.isShowingLoadingSpinner = false
                self?.registerButtonEnabled = true
            } receiveValue: { token in
                
            }

        case .tapGoToRegisterButton:
            self.userState.wrappedValue = .needsToRegister
        case .setEmailAdress(let value):
            self.email = value
        case .setPassword(let value):
            self.password = value
        }
    }
    
    //Output
    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var registerButtonEnabled: Bool = true
    
    private(set) var isShowingLoadingSpinner = false
    
    private(set) var userState: Binding<RootViewModel.UserState>
    
    var loginButtonEnabled: Bool {
        isValidEmail && isValidPassword
    }
    
    //MARK: Private
    private var isValidEmail: Bool {
        IsValid.email(self.email)
    }
    private var isValidPassword: Bool {
        IsValid.password(self.password)
    }
    
    private var userToLogin: UserLoginCandidate {
        .init(
            email: email,
            password: password
        )
    }
    
    
    private var loginRequestCancellable: AnyCancellable?
}

//MARK: Side Effects
extension LoginPageViewModel {
    struct SideEffects {
        var login: LoginRequest
    }
}

extension LoginPageViewModel.SideEffects {
    static var live: Self = .init(login: Current.api.login)
    
    static var mock: Self = .init { _ in
        Just(Token(value: ""))
            .setFailureType(to: API.Error.self)
            .eraseToAnyPublisher()
    }
}

extension LoginPageViewModel {
    enum Action {
        case tapLoginButton
        case tapGoToRegisterButton
        case setEmailAdress(_ value: String)
        case setPassword(_ value: String)
    }
}
