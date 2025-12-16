//
//  CirclesView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//


import SwiftUI
import SonderDTOs

struct CirclesView: View {
    
    @State private var circlesVM = CirclesViewModel()
    let circlesController = CirclesViewController()

    var body: some View {
        Text(circlesVM.circleInvitation?.invitation ?? "Invitation not generated")
        generateInviteCodeButton.onAppear {
            Task {
                if circlesVM.circleInvitation == nil {
                    try await circlesController.getCircleInvitation(with: circlesVM)
                }
            }
        }
    }
}

extension CirclesView {
    var generateInviteCodeButton: some View {
        GenericButton(title: "Generate Invite Code") {
            Task {
                try await circlesController.generateCircleInviteCode(with: circlesVM)
            }
        }
    }
}
