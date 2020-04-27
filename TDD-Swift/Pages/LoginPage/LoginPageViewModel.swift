//
//  LoginPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation

class LoginPageViewModel: ObservableObject, ViewModel {
    func input(_ action: LoginPageViewModel.Action) {
        switch action {
        case .didTapLoginButton(let request):
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
        case .didTapRegisterButton:
            isPresentingRegisterPage = true
        case .didDismissRegisterPage:
            isPresentingRegisterPage = false
        case .didSetEmailAdress(let value):
            self.email = value
        case .didSetPassword(let value):
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
        email.matches(
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        )
    }
    private var isValidPassword: Bool {
        password.matches(
            "^(?=.*[A-Za-z])(?=.*[0-9])(?!.*[^a-zA-Z0-9_!@#$&*]).{8,20}$"
        )
    }
}

extension LoginPageViewModel {
    enum Action {
        case didTapLoginButton(request: Request<String> = Current.api.login)
        case didTapRegisterButton
        case didDismissRegisterPage
        case didSetEmailAdress(_ value: String)
        case didSetPassword(_ value: String)
    }
}

fileprivate extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression) != nil
    }
}
