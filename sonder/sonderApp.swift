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

    @State private var onboardingModel = OnboardingModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(onboardingModel: onboardingModel)
                .onAppear {
                    let onboardingController = OnboardingController()
                    onboardingController.startup()
                }
        }
    }
}

private struct RootView: View {
    @Bindable var onboardingModel: OnboardingModel

    var body: some View {
        Group {
            switch onboardingModel.status {
            case .loading:
                SplashView()
            case .authenticatedInCircle:
                LandingPageView()
            case .notOnboarded:
                UserOnboardingView(onboardingModel: onboardingModel)
            case .authenticatedNotInCircle:
                CircleOnboardingView(onboardingModel: onboardingModel)
            case .unauthenticated:
                LoginView(onboardingModel: onboardingModel)
                    .onOpenURL { url in
                        GIDSignIn.sharedInstance.handle(url)
                    }
            case .error(let message):
                VStack(spacing: 16) {
                    Text("Error").font(.headline)
                    Text(message).font(.subheadline)
                    Button("Retry") {
                        onboardingModel.status = .unauthenticated
                    }
                }
                .padding(Constants.padding)
            }
        }
    }
}
