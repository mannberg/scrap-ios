//
//  RegisterPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-27.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import Combine
import IsValid
import scrap_data_models
import scrap_client_api

class RegisterPageViewModel: ObservableObject, ViewModel {
    
    init(sideEffects: SideEffects = .live) {
        self.sideEffects = sideEffects
    }
    
    var sideEffects: SideEffects
    
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
        case .tapRegisterButton:
            guard registerButtonEnabled else {
                return
            }
            
            hasOngoingRequest = true
            errorMessage = nil
            
            registerRequestCancellable = sideEffects.register(userToRegister).sink { [weak self] completion in
                
                switch completion {
                case .failure(let error):
                    if case .visible(let errorMessage) = error {
                        self?.errorMessage = errorMessage
                    }
                default:
                    break
                }
                
                self?.hasOngoingRequest = false
                
            } receiveValue: { token in
                //save token
            }
        }
    }
    
    //MARK: Output
    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var confirmedPassword: String = ""
    @Published private(set) var displayName: String = ""
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasOngoingRequest = false
    
    var isShowingLoadingSpinner: Bool { hasOngoingRequest }
    var textFieldsAreDisabled: Bool { hasOngoingRequest }
    
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
    
    private var registerRequestCancellable: AnyCancellable?
}

extension RegisterPageViewModel {
    enum Action {
        case setEmailAdress(_ value: String)
        case setConfirmedPassword(_ value: String)
        case setPassword(_ value: String)
        case setDisplayName(_ value: String)
        case tapRegisterButton
    }
}

extension RegisterPageViewModel {
    func input(_ actions: Action...) -> RegisterPageViewModel {
        for action in actions {
            self.input(action)
        }
        
        return self
    }
    
    static func withCorrectCredentials(sideEffects: RegisterPageViewModel.SideEffects = .mock) -> RegisterPageViewModel {
        RegisterPageViewModel(sideEffects: sideEffects)
            .input(
                .setEmailAdress(.validEmail),
                .setPassword(.validPassword),
                .setConfirmedPassword(.validPassword),
                .setDisplayName(.validDisplayName)
        )
    }
}

//MARK: Side Effects
extension RegisterPageViewModel {
    struct SideEffects {
        var register: RegisterRequest
    }
}

extension RegisterPageViewModel.SideEffects {
    static var live: RegisterPageViewModel.SideEffects = .init(register: Current.api.register)
    
    static var mock: RegisterPageViewModel.SideEffects = .init { _ in
        Just("")
            .setFailureType(to: API.Error.self)
            .eraseToAnyPublisher()
    }
}

//MARK: Helpers
extension String {
    static var validPassword: String { "abcd1234" }
    static var validEmail: String { "joe@south.com" }
    static var validDisplayName: String { "joe" }
}
