//
//  CirclesViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

final class CirclesViewModel {
    
    @Bindable var authModel: AuthModel
    let apiClient = DefaultAPIClient()
    let tokenController = TokenController()
    
    init(authModel: AuthModel) { self.authModel = authModel }
    
    func generateCircleInviteCode(with circle : CircleModel) async throws {
        let accessToken = try tokenController.loadToken(as: .access)
        let invitation = try await self.apiClient.createCircleInvitation(accessToken: accessToken)
        circle.updateInvitation(invitation)
    }
    
    func getCircleInvitation(with circle : CircleModel) async throws {
        let accessToken = try tokenController.loadToken(as: .access)
        let invitation = try await self.apiClient.getCircleInvitation(accessToken: accessToken)
        circle.updateInvitation(invitation)
    }
}
