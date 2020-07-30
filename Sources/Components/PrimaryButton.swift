//
//  PrimaryButton.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-07-24.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    @Binding var isEnabled: Bool
    
    var body: some View {
        Button(title) {
            action()
        }
        .disabled(!isEnabled)
        .foregroundColor(.white)
        .padding(10)
        .background(buttonColor)
        .cornerRadius(8)
    }
    
    var buttonColor: Color {
        isEnabled ? Color("PrimaryButtonEnabled") : .gray
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrimaryButton(
                title: "Tap me!",
                action: {},
                isEnabled: Binding.constant(true)
            )
            PrimaryButton(
                title: "Tap me!",
                action: {},
                isEnabled: Binding.constant(false)
            )
        }
    }
}
