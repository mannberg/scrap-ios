//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

class LoginPageViewModel {
    //Input
    func didTapLoginButton() {
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
    }
    
    func didSetEmailAdress(_ value: String) {
        self.email = value
    }
    
    func didSetPassword(_ value: String) {
        self.password = value
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
