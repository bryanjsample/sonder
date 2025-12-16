//
//  CircleInviteCodeView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleInviteCodeView: View {
    
    @Bindable var authModel: AuthModel
    @State private var circleInviteCode: String = ""
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                SonderTitleText.titleBlock
                Spacer(minLength: 138.0)
                inviteCodeForm
                submitButton
            }.ignoresSafeArea(.keyboard)
        }
    }
}

extension CircleInviteCodeView {
    var inviteCodeForm: some View {
        Form {
            Section("Circle Invitation") {
                TextField("Invite Code", text: $circleInviteCode)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        Button() {
            handlePress()
        } label: {
            Text("Join Circle")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.borderedProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
        .ignoresSafeArea(.keyboard)
    }
    
    func handlePress() {
        let onboardingController = OnboardingController()
        onboardingController.joinCircleViaCode(with: authModel, invitation: circleInviteCode)
    }
}

#Preview {
    CircleInviteCodeView(authModel: AuthModel())
}
