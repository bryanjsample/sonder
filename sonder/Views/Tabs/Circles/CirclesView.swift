//
//  CirclesView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//


import SwiftUI
import SonderDTOs

struct CirclesView: View {
    
    @Bindable var authModel: AuthModel
    @State private var circle = CircleModel()
    var circlesVM: CirclesViewModel? = nil
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.circlesVM = CirclesViewModel(authModel: authModel)
    }

    var body: some View {
        Text(circle.circleInvitation?.invitation ?? "Invitation not generated")
        generateInviteCodeButton.onAppear {
            Task {
                if circle.circleInvitation == nil {
                    try await circlesVM?.getCircleInvitation(with: circle)
                }
            }
        }
    }
}

extension CirclesView {
    var generateInviteCodeButton: some View {
        GenericButton(title: "Generate Invite Code") {
            Task {
                try await circlesVM?.generateCircleInviteCode(with: circle)
            }
        }
    }
}
