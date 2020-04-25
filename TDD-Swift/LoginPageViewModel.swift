//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

struct LoginPageViewModel {
    var email: String = ""
    var password: String = ""
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
    
    var isShowingLoadingSpinner = false
    
    mutating func didTapLoginButton() {
        isShowingLoadingSpinner = true
    }
}

fileprivate extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression) != nil
    }
}
