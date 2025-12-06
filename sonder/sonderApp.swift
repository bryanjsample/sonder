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

    @State private var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(authVM: authVM)
                .onAppear {
                    authVM.startup()
                }
        }
    }
}

private struct RootView: View {
    @Bindable var authVM: AuthViewModel

    var body: some View {
        Group {
            switch authVM.status {
            case .loading:
                SplashView()
            case .authenticatedInCircle:
                LandingPageView(authVM: authVM)
            case .authenticatedNotInCircle:
                CircleInviteCodeView(authVM: authVM)
            case .unauthenticated:
                LoginView(authVM: authVM)
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
                .padding(Constants.padding)
            }
        }
    }
}
