//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

struct LoginPageViewModel {
    //Input
    mutating func didTapLoginButton() {
        isShowingLoadingSpinner = true
    }
    
    mutating func didSetEmailAdress(_ value: String) {
        self.email = value
    }
    
    mutating func didSetPassword(_ value: String) {
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

fileprivate extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression) != nil
    }
}
