//
//  GenericTextInput.swift
//  sonder
//
//  Created by Bryan Sample on 12/19/25.
//

import SwiftUI

struct GenericTextInput: View {
    
    @FocusState private var isFocused: Bool
    var inputDescription: String
    var textBinding: Binding<String>
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if !isFocused && textBinding.wrappedValue.isEmpty {
                Text(inputDescription)
                    .allowsHitTesting(false)
                    .opacity(0.30)
                    .font(.body)
            }
            
            TextEditor(text: textBinding)
                .focused($isFocused)
                .font(.body)
        }
    }
    
}
