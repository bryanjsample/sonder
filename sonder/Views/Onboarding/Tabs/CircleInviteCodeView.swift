//
//  CircleInviteCodeView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleInviteCodeView: View {
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
    }
    
    var submitButton: some View {
        Button() {
            print("Joined circle")
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
    CircleInviteCodeView()
}
