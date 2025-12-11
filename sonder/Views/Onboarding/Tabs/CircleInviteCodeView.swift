//
//  CircleInviteCodeView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleInviteCodeView: View {
    
    @Bindable var onboardingModel: OnboardingModel
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
            onboardingModel.authenticatedInCircle()
        } label: {
            Text("Join Circle")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    CircleInviteCodeView(onboardingModel: OnboardingModel())
}
