//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import IsValid

class LoginPageViewModel: ObservableObject, ViewModel {
    func input(_ action: LoginPageViewModel.Action) {
        switch action {
        case .tapLoginButton(let request):
            guard loginButtonEnabled else {
                return
            }
            
            isShowingLoadingSpinner = true
            
            request { result in
                switch result {
                case .failure(_):
                    isShowingLoadingSpinner = false
                default:
                    isShowingLoadingSpinner = false
                }
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
    private(set) var isShowingLoadingSpinner = false
    
    var loginButtonEnabled: Bool {
        isValidEmail && isValidPassword
    }
    
    //Private helpers
    private var isValidEmail: Bool {
        IsValid.email(self.email)
    }
    private var isValidPassword: Bool {
        IsValid.password(self.password)
    }
}

extension LoginPageViewModel {
    enum Action {
        case tapLoginButton(request: Request<String> = Current.api.login)
        case tapRegisterButton
        case dismissRegisterPage
        case setEmailAdress(_ value: String)
        case setPassword(_ value: String)
    }
}
