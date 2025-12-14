//
//  GoogleLoginButton.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import SonderDTOs

struct GoogleLoginButton: View {
    @Bindable var onboardingModel: OnboardingModel
    
    var body: some View {
        googleButton
    }
}

extension GoogleLoginButton {
    func handlePress() {
        let onboardingController = OnboardingController()
        // Find a presenting view controller from the key window
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            print("No presenting VC")
            return
        }
        
        onboardingController.completeGoogleOAuth(with: onboardingModel, presentingVC: presentingVC)
    }

    var googleButton: some View {
        GoogleSignInButton(action: handlePress)
        .padding(Constants.padding * 4)
    }
}

extension GIDGoogleUser {
    func toDTO() -> UserDTO {
        guard let profile = self.profile else {
            // handle if no profile is included.... shouldnt be the case
            return UserDTO(email: "", firstName: "", lastName: "", isOnboarded: false)
        }
        let dto = UserDTO(email: profile.email, firstName: profile.givenName ?? "", lastName: profile.familyName ?? "", isOnboarded: false)
        return dto
        
    }
}
//
//#Preview {
//    GoogleLoginButton()
//}
