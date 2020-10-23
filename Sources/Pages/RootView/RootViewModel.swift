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
    @Published private(set) var userState: UserState = .undetermined
    
    //MARK: Private
    private var cancellables = Set<AnyCancellable>()
    private var sideEffects: SideEffects
    
    //MARK: Methods
    init(sideEffects: SideEffects = .live) {
        self.sideEffects = sideEffects
        
        sideEffects.hasToken
            .map { $0 ? .loggedIn : .needsToRegister }
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
    }
}

extension RootViewModel.SideEffects {
    static var live: Self {
        Self(
            hasToken: Current.api.hasToken,
            clearToken: { Current.api.clearToken() }
        )
    }
}
