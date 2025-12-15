//
//  CirclesViewController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

final class CirclesViewController {
    let apiClient = DefaultAPIClient()
    
    init() { }
    
    func generateCircleInviteCode(with circlesVM: CirclesViewModel) async throws {
        let tokenController = TokenController()
        let accessToken = try tokenController.loadToken(as: .access)
        let invitation = try await self.apiClient.createCircleInvitation(accessToken: accessToken)
        circlesVM.updateInvitation(invitation)
    }
}
