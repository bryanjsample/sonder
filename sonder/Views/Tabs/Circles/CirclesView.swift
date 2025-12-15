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
    
    var body: some View {
        Text(circlesVM.circleInvitation?.invitation ?? "Invitation not generated")
        generateInviteCodeButton
    }
}

extension CirclesView {
    var generateInviteCodeButton: some View {
        Button() {
            Task {
                try await handlePress()
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
    
    func handlePress() async throws {
        let circlesController = CirclesViewController()
        try await circlesController.generateCircleInviteCode(with: circlesVM)
    }
}
