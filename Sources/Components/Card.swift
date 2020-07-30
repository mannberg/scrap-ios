//
//  Card.swift
//  Scrap
//
//  Created by Anders Mannberg on 2020-07-29.
//  Copyright © 2020 Mannberg. All rights reserved.
//

import SwiftUI

struct Card<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            content()
        }
        .background(Color("Card"))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(15)
        .padding(.top, 5)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card {
            Text("Heja")
        }
    }
}
