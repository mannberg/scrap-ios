//
//  RegisterPage.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-05-14.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine
import Environment

struct RegisterPage: View {
    @StateObject var viewModel = RegisterPageViewModel()
    
    var body: some View {
        return NavigationView {
            VStack {
                Card {
                    
                    Input(
                        title: "Display name",
                        placeholder: "Display name",
                        binding: self.viewModel.binding(
                            get: \.displayName,
                            toAction: { .setDisplayName($0) }
                        ),
                        textContentType: .name
                    )
                    .disabled(self.viewModel.textFieldsAreDisabled)
                    
                    Input(
                        title: "Email adress",
                        placeholder: "Email adress",
                        binding: self.viewModel.binding(
                            get: \.email,
                            toAction: { .setEmailAdress($0) }
                        ),
                        textContentType: .emailAddress
                    )
                    .disabled(self.viewModel.textFieldsAreDisabled)
                    
                    Input(
                        title: "Password",
                        placeholder: "Password",
                        binding: self.viewModel.binding(
                            get: \.password,
                            toAction: { .setPassword($0) }
                        ),
                        textContentType: .password,
                        type: .secure
                    )
                    .disabled(self.viewModel.textFieldsAreDisabled)
                    
                    Input(
                        title: "Confirm password",
                        placeholder: "Confirm password",
                        binding: self.viewModel.binding(
                            get: \.confirmedPassword,
                            toAction: { .setConfirmedPassword($0) }
                        ),
                        textContentType: .password,
                        type: .secure
                    )
                    .disabled(self.viewModel.textFieldsAreDisabled)
                    
                    HStack {
                        Spacer()
                        PrimaryButton(
                            title: "Register",
                            action: { viewModel.input(.tapRegisterButton()) },
                            isEnabled: viewModel.binding(get: \.registerButtonEnabled)
                        )
                        Spacer()
                    }
                    .padding([.top, .bottom], 15)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .cornerRadius(8)
                            .padding([.top, .bottom], 15)
                    }
                    
                    if viewModel.isShowingLoadingSpinner {
                        ProgressView("")
                    }
                }
                
                Spacer()
            }
//            .background(Color("Background").edgesIgnoringSafeArea(.all))
            .background(LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Card")]), startPoint: .top, endPoint: .bottom))
//            .navigationBarTitle("Register account", displayMode: .inline)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
//                        Image(systemName: "sun.min.fill")
                        Text("Register Account")
                            .font(.headline)
                            
                    }
                }
            }
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                callback(
                    .failure(
                        .server(
                            message: "Error!"
                        )
                    )
                )
                
            }
            
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
        let darkPage = RegisterPage(viewModel: viewModel).environment(\.colorScheme, .dark)
        
        return Group {
            page
            darkPage
        }
    }
}

struct RegisterPage_Previews_ProgressView: PreviewProvider {
    static var previews: some View {
        let viewModel = RegisterPageViewModel.withCorrectCredentials
        viewModel.input(.tapRegisterButton { _, _ in
            
        })
        
        let page = RegisterPage(viewModel: viewModel)
        let darkPage = RegisterPage(viewModel: viewModel).environment(\.colorScheme, .dark)
        
        return Group {
            page
            darkPage
        }
    }
}

