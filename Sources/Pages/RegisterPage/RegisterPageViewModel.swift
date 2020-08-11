//
//  RegisterPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-27.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import IsValid
import Environment
import scrap_data_models

class RegisterPageViewModel: ObservableObject, ViewModel {
    func input(_ action: RegisterPageViewModel.Action) {
        switch action {
        case .setEmailAdress(let value):
            email = value
        case .setPassword(let value):
            password = value
        case .setDisplayName(let value):
            displayName = value
        case .setConfirmedPassword(let value):
            confirmedPassword = value
        case .tapRegisterButton(let request):
            guard registerButtonEnabled else {
                return
            }
            
            hasOngoingRequest = true
            errorMessage = nil
            
            request(userToRegister) { [weak self] result in
                switch result {
                case .failure(let error):
                    if case .server(let errorMessage) = error {
                        self?.errorMessage = errorMessage
                    }
                    self?.hasOngoingRequest = false
                default:
                    self?.hasOngoingRequest = false
                }
            }
        }
    }
    
    //Output
    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var confirmedPassword: String = ""
    @Published private(set) var displayName: String = ""
    @Published private(set) var errorMessage: String?
    
    var isShowingLoadingSpinner: Bool { hasOngoingRequest }
    var textFieldsAreDisabled: Bool { hasOngoingRequest }
    
    private(set) var hasOngoingRequest = false
    
    var registerButtonEnabled: Bool {
        if hasOngoingRequest {
            return false
        }
        
        return isValidDisplayName
        && isValidEmail
        && isValidPassword
        && isValidConfirmedPassword
    }
    
    var isValidEmail: Bool {
        IsValid.email(self.email)
    }
    
    var isValidPassword: Bool {
        IsValid.password(self.password)
    }
    
    var isValidConfirmedPassword: Bool {
        IsValid.password(self.password) && self.confirmedPassword == self.password
    }
    
    var isValidDisplayName: Bool {
        IsValid.displayName(self.displayName)
    }
    
    //MARK: Private
    private var userToRegister: UserRegistrationCandidate {
        .init(
            displayName: displayName,
            email: email,
            password: password
        )
    }
}

extension RegisterPageViewModel {
    enum Action {
        case setEmailAdress(_ value: String)
        case setConfirmedPassword(_ value: String)
        case setPassword(_ value: String)
        case setDisplayName(_ value: String)
        case tapRegisterButton(request: RegisterRequest = Current.api.register)
    }
}

extension RegisterPageViewModel {
    func input(_ actions: Action...) -> RegisterPageViewModel {
        for action in actions {
            self.input(action)
        }
        
        return self
    }
    
    static var withCorrectCredentials: RegisterPageViewModel {
        RegisterPageViewModel()
            .input(
                .setEmailAdress(.validEmail),
                .setPassword(.validPassword),
                .setConfirmedPassword(.validPassword),
                .setDisplayName(.validDisplayName)
        )
    }
}

extension String {
    static var validPassword: String { "abcd1234" }
    static var validEmail: String { "joe@south.com" }
    static var validDisplayName: String { "joe" }
}
