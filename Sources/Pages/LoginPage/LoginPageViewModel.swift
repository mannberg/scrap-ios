//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import IsValid
import scrap_client_api

class LoginPageViewModel: ObservableObject, ViewModel {
    
    func input(_ action: LoginPageViewModel.Action) {
        switch action {
        case .tapLoginButton(let request):
            guard loginButtonEnabled else {
                return
            }
            
            isShowingLoadingSpinner = true
            registerButtonEnabled = false
            
            let dummy = UserLoginCandidate(email: "", password: "")
            
            //TODO: Add Cancellable
            _ = request(dummy).sink { [weak self] completion in
                self?.isShowingLoadingSpinner = false
                self?.registerButtonEnabled = true
            } receiveValue: { token in
                //save login token
            }

        case .tapRegisterButton:
            isPresentingRegisterPage = true
        case .dismissRegisterPage:
            isPresentingRegisterPage = false
        case .setEmailAdress(let value):
            self.email = value
        case .setPassword(let value):
            self.password = value
        }
    }
    
    //Output
    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var isPresentingRegisterPage: Bool = false
    @Published private(set) var registerButtonEnabled: Bool = true
    private(set) var isShowingLoadingSpinner = false
    
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
}

extension LoginPageViewModel {
    enum Action {
        case tapLoginButton(request: LoginRequest = Current.api.login)
        case tapRegisterButton
        case dismissRegisterPage
        case setEmailAdress(_ value: String)
        case setPassword(_ value: String)
    }
}
