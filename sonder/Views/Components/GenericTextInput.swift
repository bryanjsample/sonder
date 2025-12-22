//
//  GenericTextEditor.swift
//  sonder
//
//  Created by Bryan Sample on 12/19/25.
//

import SwiftUI

struct GenericTextEditor: View {
    
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
                    .fontDesign(.monospaced)
            }
            
            TextEditor(text: textBinding)
                .frame(maxHeight: maxTextHeight())
                .focused($isFocused)
                .font(.body)
                .lineLimit(15)
        }
    }
}

extension GenericTextEditor {
    func minTextHeight() -> CGFloat {
        UIFont.preferredFont(forTextStyle: .body).lineHeight
    }
    
    func maxTextHeight() -> CGFloat {
        UIFont.preferredFont(forTextStyle: .body).lineHeight * 10
    }
}


#Preview {
    LandingPageView(authModel: AuthModel())
}
