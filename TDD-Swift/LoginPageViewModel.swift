//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

class LoginPageViewModel {
    func input(_ action: LoginPageViewModel.Action) {
        switch action {
        case .didTapLoginButton:
            guard loginButtonEnabled else {
                return
            }
            
            CurrentAPI.login { result in
                switch result {
                case .failure(_):
                    isShowingLoadingSpinner = false
                default:
                    break
                }
            }
            
            isShowingLoadingSpinner = true
        case .didSetEmailAdress(let value):
            self.email = value
        case .didSetPassword(let value):
            self.password = value
        }
    }
    
    //Output
    private(set) var email: String = ""
    private(set) var password: String = ""
    private(set) var isShowingLoadingSpinner = false
    
    var isValidEmail: Bool {
        email.matches(
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        )
    }
    var isValidPassword: Bool {
        password.matches(
            "^(?=.*[A-Za-z])(?=.*[0-9])(?!.*[^a-zA-Z0-9_!@#$&*]).{8,20}$"
        )
    }
    var loginButtonEnabled: Bool {
        isValidEmail && isValidPassword
    }
}

extension LoginPageViewModel {
    enum Action {
        case didTapLoginButton
        case didSetEmailAdress(_ value: String)
        case didSetPassword(_ value: String)
    }
}

var CurrentAPI = API()


struct API {
    var login: ((Result<String, API.Error>) -> Void) -> Void = { _ in
        
    }
}

extension API {
    enum Error: Swift.Error {
        case server
    }
}

fileprivate extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression) != nil
    }
}
