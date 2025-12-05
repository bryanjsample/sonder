//
//  LoginViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SwiftUI
import SonderDTOs

@MainActor
@Observable
final class LoginViewModel {
    @State var route: LoginRoute? = nil
    private let loginManager: LoginManager = LoginManager()
    
    init() { }
    
    func completeGoogleSignIn(with userDTO: UserDTO) async {
        do {
            let result = try await DefaultAPIClient.signInWithGoogle(userDTO)

            loginManager.storeTokens(access: result.accessToken.token, refresh: result.refreshToken.token)

            if result.needsToBeOnboarded {
                route = .onboarding(userDTO)
                
            } else {
                if result.userInGroup {
                    route = .circleHome(userDTO)
                } else {
                    route = .circleInvitation
                }
            }
        } catch {
            route = .error(error.localizedDescription)
        }
    }
    
}
