//
//  sonderApp.swift
//  sonder
//
//  Created by Bryan Sample on 11/23/25.
//

import SwiftUI
import GoogleSignIn
import SonderDTOs

@main
struct sonderApp: App {
    
    @State var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(authVM: $authVM)
                .onAppear {
                    authVM.startup()
                }
        }
    }
}

private struct RootView: View {
    @Binding var authVM: AuthViewModel

    var body: some View {
        Group {
            switch authVM.state {
            case .loading:
                SplashView() // simple loading view or progress indicator
            case .authenticatedInCircle:
                LandingPageView()
            case .authenticatedNotInCircle:
                CircleInviteCodeView()
            case .unauthenticated:
                LoginView()
                    .onAppear {
                        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                            if let info = user {
                                print(info)
                            }
                            if let err = error {
                                print(err)
                            }
                           
                        }
                    }
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            case .error(let message):
                VStack(spacing: 16) {
                    Text("Error").font(.headline)
                    Text(message).font(.subheadline)
                    Button("Retry") {
                        authVM.startup()
                    }
                }
                .padding()
            }
        }
    }
}
