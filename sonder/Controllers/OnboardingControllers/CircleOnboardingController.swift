//
//  CircleOnboardingController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import Foundation
import SonderDTOs

extension OnboardingController {
    func onboardNewCircle(with authModel: AuthModel, circleName: String, description: String) {
        self.runOnboardingFlow(with: authModel) {
            let dto = CircleDTO(name: circleName, description: description)
            authModel.updateCircle(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.createCircle(dto, accessToken: accessToken)
            authModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            authModel.updateUser(user)
            self.transition(with: authModel)
        }
    }
    
    func joinCircleViaCode(with authModel: AuthModel, invitation: String) {
        self.runOnboardingFlow(with: authModel) {
            let dto = InvitationStringDTO(invitation)
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.joinCircleViaInvitation(dto, accessToken: accessToken)
            authModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            authModel.updateUser(user)
            self.transition(with: authModel)
        }
    }
}
