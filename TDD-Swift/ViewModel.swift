//
//  ViewModel.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

protocol ViewModel {
    associatedtype Action
    func input(_ action: Action)
}

extension ViewModel {
    func binding<Value>(
        get: KeyPath<Self, Value>,
        action: Action
    ) -> Binding<Value> {
        Binding(
            get: { self[keyPath: get] },
            set: { _ in self.input(action) }
        )
    }
    
    func binding<Value>(
        get: KeyPath<Self, Value>,
        toAction: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding(
            get: { self[keyPath: get] },
            set: { self.input(toAction($0)) }
        )
    }
}
