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
                title: "Email adress",
                placeholder: "Email adress",
                binding: self.viewModel.binding(
                    get: \.email,
                    toAction: { .setEmailAdress($0) }
                ),
                textContentType: .emailAddress
            )
            Input(
                title: "Password",
                placeholder: "Password",
                binding: self.viewModel.binding(
                    get: \.password,
                    toAction: { .setPassword($0) }
                ),
                textContentType: .password
            )

            Button("Login") {
                self.viewModel.input(.tapLoginButton())
            }.disabled(!viewModel.loginButtonEnabled)
            
            Button(action: { self.viewModel.input(.tapRegisterButton) }, label: { Text("Register") }).sheet(isPresented: viewModel.binding(
                get: \.isPresentingRegisterPage,
                toAction: { _ in .dismissRegisterPage }
            )) {
                Text("Modal")
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
