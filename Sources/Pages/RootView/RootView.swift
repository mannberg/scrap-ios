//
//  RootView.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-10-23.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = RootViewModel()
    
    var body: some View {
        switch viewModel.userState {
        case .loggedIn:
            Button("Clear token!") {
                withAnimation {
                    viewModel.input(.didTapClearTokenButton)
                }
            }
        case .needsToRegister:
            RegisterPage().transition(.move(edge: .bottom))
        case .needsToLogin:
            LoginPage().transition(.move(edge: .bottom))
        case .undetermined:
            RegisterPage().transition(.move(edge: .bottom))
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
