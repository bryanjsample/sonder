//
//  CircleOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleOnboardingView: View {
    
    @Bindable var onboardingModel: OnboardingModel
    @State var tabSelection: CircleOnboardingRoute = .invite
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Invitation", systemImage: "envelope.open", value: .invite) {
                CircleInviteCodeView(onboardingModel: onboardingModel)
            }
            Tab("Create", systemImage: "plus", value: .create) {
                CreateCircleView(onboardingModel: onboardingModel)
            }
        }
    }
}

#Preview {
    CircleOnboardingView(onboardingModel: OnboardingModel())
}
