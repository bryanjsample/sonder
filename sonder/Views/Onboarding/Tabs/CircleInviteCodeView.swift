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
                SonderTitleText()
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
        GenericButton(title: "Join Circle") {
            let onboardingController = OnboardingController(authModel: authModel)
            onboardingController.joinCircleViaCode(invitation: circleInviteCode)
        }
    }
}

#Preview {
    CircleInviteCodeView(authModel: AuthModel())
}
