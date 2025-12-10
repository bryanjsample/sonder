//
//  CircleInviteCodeView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleInviteCodeView: View {
    
    @Bindable var authVM: AuthViewModel
    @State private var circleInviteCode: String = ""
    
    var body: some View {
        SonderTitleText.titleBlock
        Spacer(minLength: 138.0)
        inviteCodeForm
        submitButton
    }
}

extension CircleInviteCodeView {
    var inviteCodeForm: some View {
        Form {
            Section("Circle Invitation") {
                TextField("Invite Code", text: $circleInviteCode)
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        Button() {
            authVM.createCircle()
        } label: {
            Text("Join Circle")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
}

#Preview {
    CircleInviteCodeView(authVM: AuthViewModel())
}
