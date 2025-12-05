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
    var body: some View {
        googleButton
    }
}

extension GoogleLoginButton {
    func handlePress() {
        // Find a presenting view controller from the key window
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            print("No presenting VC")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            if let error = error {
                // Handle the error without throwing
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let result = signInResult else {
                print("Google Sign-In: No result returned")
                return
            }

            let user = result.user
            
            let userDTO = user.toDTO()
            
            /*Look at GoogleLoginButton.swift at the handlePress() function. I have written in pseudocode what I would like the function to do. What is the best way to do this considering it is located within the closure for GIDSignIn?*/
            
            // SEND HTTP REQUEST TO /auth/google/success TO OBTAIN ACCESS AND REFRESH KEYS
            
            // DETERMINE IF USER ALREADY EXISTS SEND BACK BOOL FROM SERVER
            
            // IF USER EXISTS
                // IF USER IS IN A GROUP, ADVANCE TO HOMPAGE
                // ELSE ADVANCE TO INVITATION VIEW
            // ELSE
                // ADVANCE TO ONBOARDING VIEW PASSING IN USERDTO TO FILL IN SHEET WITH APPROPRIATE SLOTS
            
            print("Google Sign-In succeeded for user: \(result.user.profile?.email ?? "<unknown>")")
        }
        
        
        
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
            return UserDTO(email: "", firstName: "", lastName: "")
        }
        var dto = UserDTO(email: profile.email, firstName: profile.givenName ?? "", lastName: profile.familyName ?? "")
        return dto
        
    }
}

#Preview {
    GoogleLoginButton()
}
