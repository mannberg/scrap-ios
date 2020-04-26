//
//  ContentView.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-25.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine

struct LoginPage: View {
    @ObservedObject var viewModel = LoginPageViewModel()
    
    var body: some View {
        
        return VStack {
            Input(
                placeholder: "Email adress",
                binding: self.viewModel.binding(
                    get: \.email,
                    toAction: { .didSetEmailAdress($0) }
                )
            )
            Input(
                placeholder: "Password",
                binding: self.viewModel.binding(
                    get: \.password,
                    toAction: { .didSetPassword($0) }
                )
            )

            Button("Login") {
                self.viewModel.input(.didTapLoginButton)
            }.disabled(!viewModel.loginButtonEnabled)
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
