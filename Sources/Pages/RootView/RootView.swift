//
//  RootView.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-10-23.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = RootViewModel()
    
    var body: some View {
        switch viewModel.userState {
        case .loggedIn:
            Button("Clear token!") {
                withAnimation {
                    viewModel.input(.didTapClearTokenButton)
                }
            }
        case .needsToRegister:
            RegisterPage(viewModel: .init(
                userState: $viewModel.userState,
                sideEffects: .live
            ))
            .transition(.slide)
        case .needsToLogin:
            LoginPage(viewModel: .init(userState: $viewModel.userState))
                .transition(.slide)
        case .undetermined:
            Text("Hey!")
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
