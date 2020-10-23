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
    @ObservedObject var viewModel: LoginPageViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Card {
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

                    HStack {
                        Spacer()
                        PrimaryButton(
                            title: "Login",
                            action: { viewModel.input(.tapLoginButton()) },
                            isEnabled: viewModel.binding(get: \.loginButtonEnabled)
                        )
                        Spacer()
                    }
                    .padding([.top, .bottom], 15)
                    
                    Button(action:  { withAnimation {
                        viewModel.input(.tapGoToRegisterButton)
                    }}) {
                        Text("Register a new account!")
                            .font(.subheadline)
                            .foregroundColor(Color("PrimaryButtonEnabled"))
                    }
                    .padding(.bottom, 20)
                }
                Spacer()
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Login")
                            .font(.headline)
                            
                    }
                }
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage(viewModel: .init(userState: .constant(.needsToLogin)))
    }
}
