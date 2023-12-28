//
//  WErrorModifier.swift
//  WordScramble
//
//  Created by Víctor Barrios Sánchez on 29/12/23.
//

import SwiftUI

extension View {
    func manage(error: WordError?, when: Binding<Bool>) -> some View {
        modifier(WordErrorModifier(error: error, when: when))
    }
}

private struct WordErrorModifier: ViewModifier {
    let error: WordError?
    let when: Binding<Bool>
    
    func body(content: Content) -> some View {
        content
            .alert(error?.info.title ?? "",
                   isPresented: when) {
                Button("Ok") {}
            } message: {
                Text(error?.info.description ?? "")
            }
    }
}
