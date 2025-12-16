//
//  UserProfileView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

struct UserProfileView: View {
    @Bindable var onboardingModel: OnboardingModel
    
    var body: some View {
        signOutButton
    }
}

extension UserProfileView {
    var signOutButton: some View {
        Button() {
            Task {
                await handlePress()
            }
        } label: {
            Text("Sign Out of Sonder")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.borderedProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
    
    func handlePress() async {
        let onboardingController = OnboardingController()
        onboardingController.signOut(with: onboardingModel)
    }
}
