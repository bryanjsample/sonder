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
    @State private var circlesVM = CirclesViewModel()
    var circlesController: CirclesViewController? = nil
    
    init(authModel: AuthModel, circlesVM: CirclesViewModel = CirclesViewModel()) {
        self.authModel = authModel
        self.circlesVM = circlesVM
        self.circlesController = CirclesViewController(authModel: authModel)
    }

    var body: some View {
        Text(circlesVM.circleInvitation?.invitation ?? "Invitation not generated")
        generateInviteCodeButton.onAppear {
            Task {
                if circlesVM.circleInvitation == nil {
                    try await circlesController?.getCircleInvitation(with: circlesVM)
                }
            }
        }
    }
}

extension CirclesView {
    var generateInviteCodeButton: some View {
        GenericButton(title: "Generate Invite Code") {
            Task {
                try await circlesController?.generateCircleInviteCode(with: circlesVM)
            }
        }
    }
}
