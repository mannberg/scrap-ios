//
//  RegisterPageViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-27.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import Foundation
import IsValid

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
        }
    }
    
    @Published private(set) var email: String = ""
    @Published private(set) var password: String = ""
    @Published private(set) var confirmedPassword: String = ""
    @Published private(set) var displayName: String = ""
    
    //Output
    var registerButtonEnabled: Bool {
        false
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
}

extension RegisterPageViewModel {
    enum Action {
        case setEmailAdress(_ value: String)
        case setConfirmedPassword(_ value: String)
        case setPassword(_ value: String)
        case setDisplayName(_ value: String)
    }
}
