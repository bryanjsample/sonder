//
//  UserProfileView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

struct UserProfileView: View {
    @Bindable var authModel: AuthModel
    
    var body: some View {
        signOutButton
    }
}

extension UserProfileView {
    var signOutButton: some View {
        GenericButton(title: "Sign Out of Sonder") {
            let onboardingController = OnboardingController()
            onboardingController.signOut(with: authModel)        }
    }
}
