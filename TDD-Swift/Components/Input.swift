//
//  Input.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct Input: View {
    let placeholder: String
    let binding: Binding<String>
    var body: some View {
        TextField(placeholder, text: binding)
        .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
    }
}

struct Input_Previews: PreviewProvider {
    static var previews: some View {
        Input(
            placeholder: "Placeholder",
            binding: Binding(
                get: { "" },
                set: { _ in }
            )
        )
    }
}
