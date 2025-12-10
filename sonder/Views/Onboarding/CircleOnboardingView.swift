//
//  CircleOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleOnboardingView: View {
    @State var tabSelection: CircleOnboardingRoute = .invite
    @Bindable var authVM: AuthViewModel
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Invitation", systemImage: "envelope.open", value: .invite) {
                CircleInviteCodeView()
            }
            Tab("Create", systemImage: "plus", value: .create) {
                CreateCircleView()
            }
        }
    }
}

#Preview {
    CircleOnboardingView(authVM: AuthViewModel())
}
