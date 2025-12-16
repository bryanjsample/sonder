//
//  CircleOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CircleOnboardingView: View {
    
    @Bindable var authModel: AuthModel
    @State var tabSelection: CircleOnboardingRoute = .invite
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Invitation", systemImage: "envelope.open", value: .invite) {
                CircleInviteCodeView(authModel: authModel)
            }
            Tab("Create", systemImage: "plus", value: .create) {
                CreateCircleView(authModel: authModel)
            }
        }
    }
}

#Preview {
    CircleOnboardingView(authModel: AuthModel())
}
