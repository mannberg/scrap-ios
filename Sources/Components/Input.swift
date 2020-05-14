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
        VStack(alignment: .leading, spacing: 0) {
            Text("Hej")
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            TextField(placeholder, text: binding)
                .textFieldStyle(InputStyle())
        }
        .padding([.leading, .trailing], 10)
    }
}

struct InputStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
      configuration
        .padding(15)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.gray, lineWidth: 1)
      )
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
