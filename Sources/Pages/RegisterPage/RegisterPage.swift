//
//  RegisterPage.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-05-14.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine
import scrap_client_api
import scrap_data_models

struct RegisterPage: View {
    @ObservedObject var viewModel: RegisterPageViewModel
    
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
                            action: { viewModel.input(.tapRegisterButton) },
                            isEnabled: viewModel.binding(get: \.registerButtonEnabled)
                        )
                        Spacer()
                    }
                    .padding([.top, .bottom], 10)
                    
                    Button(action:  { withAnimation {
                        viewModel.input(.tapGoToLoginButton)
                    }}) {
                        Text("I already have an account!")
                            .font(.subheadline)
                            .foregroundColor(Color("PrimaryButtonEnabled"))
                    }
                    .padding(.bottom, 20)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .cornerRadius(8)
                            .padding(.bottom, 15)
                    }
                    
                    if viewModel.isShowingLoadingSpinner {
                        ProgressView("")
                    }
                }
                
                Spacer()
            }
            .background(Color("Background").edgesIgnoringSafeArea(.all))
//            .background(LinearGradient(gradient: Gradient(colors: [Color("Background"), Color("Card")]), startPoint: .top, endPoint: .bottom))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
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
        RegisterPage(viewModel: .init())
    }
}

struct RegisterPage_Previews_RegisterButtonEnabled: PreviewProvider {
    static var previews: some View {
        
        let sideEffects = RegisterPageViewModel.SideEffects { _ in
            
            Fail<String, API.Error>(error: API.Error.visible(message: "Error!"))
                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
            
        }

        let page = RegisterPage(
            viewModel: RegisterPageViewModel.withCorrectCredentials(sideEffects: sideEffects)
        )
        
        return page
    }
}

struct RegisterPage_Previews_RegisterButtonEnabled_SilentError: PreviewProvider {
    static var previews: some View {
        
        let sideEffects = RegisterPageViewModel.SideEffects { _ in
            Fail<String, API.Error>(error: API.Error.silent)
                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
            
        }
        
        let page = RegisterPage(
            viewModel: RegisterPageViewModel.withCorrectCredentials(sideEffects: sideEffects)
        )
        
        return page
    }
}

struct RegisterPage_Previews_ErrorMessage: PreviewProvider {
    static var previews: some View {
        
        let sideEffects = RegisterPageViewModel.SideEffects { _ in
            Fail<String, API.Error>(error: API.Error.visible(message: "Error!"))
                .eraseToAnyPublisher()
        }
        
        let viewModel = RegisterPageViewModel.withCorrectCredentials(sideEffects: sideEffects)
        
        viewModel.input(.tapRegisterButton)
        
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
        
        let sideEffects = RegisterPageViewModel.SideEffects { _ in
            Fail<String, API.Error>(error: API.Error.silent)
                .delay(for: 0.5, scheduler: RunLoop.main)
                .eraseToAnyPublisher()
            
        }
        
        let viewModel = RegisterPageViewModel.withCorrectCredentials(sideEffects: sideEffects)
        viewModel.input(.tapRegisterButton)
        
        let page = RegisterPage(viewModel: viewModel)
        let darkPage = RegisterPage(viewModel: viewModel).environment(\.colorScheme, .dark)
        
        return Group {
            page
            darkPage
        }
    }
}

