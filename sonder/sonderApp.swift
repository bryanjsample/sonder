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

    @State private var authModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(authModel: authModel)
                .onAppear {
                    let onboardingController = OnboardingController()
                    Task {
                        await onboardingController.startup(with: authModel)
                    }
                }
        }
    }
}

private struct RootView: View {
    @Bindable var authModel: AuthModel

    var body: some View {
        Group {
            switch authModel.status {
            case .loading:
                SplashView()
            case .authenticatedInCircle:
                LandingPageView(authModel: authModel)
            case .notOnboarded:
                UserOnboardingView(authModel: authModel)
            case .authenticatedNotInCircle:
                CircleOnboardingView(authModel: authModel)
            case .unauthenticated:
                LoginView(authModel: authModel)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            case .error(let message):
                VStack(spacing: 16) {
                    Text("Error").font(.headline)
                    Text(message).font(.subheadline)
                    Button("Retry") {
                        authModel.unauthenticated()
                    }
                }
                .padding(Constants.padding)
            }
        }
    }
}
