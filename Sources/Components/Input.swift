//
//  Input.swift
//  TDD-Swift
//
//  Created by Anders Mannberg on 2020-04-26.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct Input: View {
    let title: String
    let placeholder: String
    let binding: Binding<String>
    let textContentType: UITextContentType
    var type: TextType = .text
//    @Binding var isEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            input(forType: self.type)
//                .disabled(!isEnabled)
                .textContentType(textContentType)
                .disableAutocorrection(true)
                .font(.system(size: 16))
            Divider()
                .background(Color("Background"))
                .padding(.top, 10)
        }
        .padding([.leading, .trailing], 15)
        .padding([.bottom], 10)
    }
}

extension Input {
    enum TextType {
        case text
        case secure
    }
    
    func input(forType type: TextType) -> some View {
        Group {
            switch type {
            case .text:
                TextField("", text: binding)
            case .secure:
                SecureField("", text: binding)
            }
        }
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
            title: "Title",
            placeholder: "Placeholder",
            binding: Binding(
                get: { "Some value" },
                set: { _ in }
            ),
            textContentType: .name
        )
        
    }
}
