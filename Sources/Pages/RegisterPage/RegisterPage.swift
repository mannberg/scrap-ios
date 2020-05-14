//
//  RegisterPage.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-05-14.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine

struct RegisterPage: View {
    @ObservedObject var viewModel = RegisterPageViewModel()
    
    var body: some View {
        return VStack {
            Input(
                placeholder: "Display name",
                binding: self.viewModel.binding(
                    get: \.displayName,
                    toAction: { .setDisplayName($0) }
                )
            )
            Input(
                placeholder: "Email adress",
                binding: self.viewModel.binding(
                    get: \.email,
                    toAction: { .setEmailAdress($0) }
                )
            )
            Input(
                placeholder: "Password",
                binding: self.viewModel.binding(
                    get: \.password,
                    toAction: { .setPassword($0) }
                )
            )
            Input(
                placeholder: "Confirm password",
                binding: self.viewModel.binding(
                    get: \.confirmedPassword,
                    toAction: { .setConfirmedPassword($0) }
                )
            )

            Button("Register") {
                self.viewModel.input(.tapRegisterButton())
            }.disabled(!viewModel.registerButtonEnabled)
            
            viewModel.errorMessage.map {Text($0)}
        }
    }
}

struct RegisterPage_Previews_InitialState: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}

struct RegisterPage_Previews_RegisterButtonEnabled: PreviewProvider {
    static var previews: some View {
        Current.api.register = { _, callback in
            callback(
                .failure(
                    .server(
                        message: ""
                    )
                )
            )
        }
        let page = RegisterPage(viewModel: RegisterPageViewModel.withCorrectCredentials)
        return page
    }
}

struct RegisterPage_Previews_ErrorMessage: PreviewProvider {
    static var previews: some View {
        let viewModel = RegisterPageViewModel.withCorrectCredentials
        viewModel.input(.tapRegisterButton { _, callback in
            callback(
                .failure(
                    .server(
                        message: "Error!"
                    )
                )
            )
        })
        
        let page = RegisterPage(viewModel: viewModel)
        return page
    }
}

