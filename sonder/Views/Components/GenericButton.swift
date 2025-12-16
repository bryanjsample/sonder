//
//  GenericButton.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

struct GenericButton: View {
    var title: String
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.borderedProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
        .ignoresSafeArea(.keyboard)
    }
}
