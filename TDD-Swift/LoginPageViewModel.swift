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
        email == "joe@south.com"
    }
    var isValidPassword: Bool {
        password == "abcd1234"
    }
    var loginButtonEnabled: Bool {
        isValidEmail && isValidPassword
    }
}
