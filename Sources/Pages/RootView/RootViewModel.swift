//
//  RootViewModel.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-10-23.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject, ViewModel {
    //MARK: Enums
    enum Action {
        case didTapClearTokenButton
    }
    
    enum UserState {
        case undetermined
        case needsToLogin
        case needsToRegister
        case loggedIn
    }
    
    //MARK: Output
    @Published var userState: UserState = .undetermined
    
    //MARK: Private
    private var cancellables = Set<AnyCancellable>()
    private var sideEffects: SideEffects
    
    //MARK: Methods
    init(sideEffects: SideEffects = .live) {
        self.sideEffects = sideEffects
        
        sideEffects.hasToken
            .map { $0 ? .loggedIn : ( sideEffects.isFirstTimeLaunch() ? .needsToRegister : .needsToLogin) }
            .assign(to: \.userState, on: self)
            .store(in: &cancellables)
    }
    
    func input(_ action: Action) {
        switch action {
        case .didTapClearTokenButton:
            self.sideEffects.clearToken()
        }
    }
}

extension RootViewModel {
    struct SideEffects {
        var hasToken: CurrentValueSubject<Bool, Never>
        var clearToken: () -> Void
        var isFirstTimeLaunch: () -> Bool
    }
}

extension RootViewModel.SideEffects {
    static var live: Self {
        Self(
            hasToken: Current.api.hasToken,
            clearToken: { Current.api.clearToken() },
            isFirstTimeLaunch: { false }
        )
    }
    
    static var mock: Self {
        Self(
            hasToken: .init(true),
            clearToken: { fatalError("Not implemented!") },
            isFirstTimeLaunch: { fatalError("Not implemented!") }
        )
    }
}
