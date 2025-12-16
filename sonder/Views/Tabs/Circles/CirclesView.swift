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
        Button() {
            Task {
                try await circlesController.generateCircleInviteCode(with: circlesVM)
            }
        } label: {
            Text("Generate Invite Code")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
        .ignoresSafeArea(.keyboard)
    }
}
