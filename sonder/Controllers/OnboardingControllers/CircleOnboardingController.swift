//
//  CircleOnboardingController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import Foundation
import SonderDTOs

extension OnboardingController {
    func onboardNewCircle(circleName: String, description: String) {
        self.runOnboardingFlow() {
            let dto = CircleDTO(name: circleName, description: description)
            self.authModel.updateCircle(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let accessToken = try self.tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.createCircle(dto, accessToken: accessToken)
            self.authModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            self.authModel.updateUser(user)
            self.transition()
        }
    }
    
    func joinCircleViaCode(invitation: String) {
        self.runOnboardingFlow() {
            let dto = InvitationStringDTO(invitation)
            let accessToken = try self.tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.joinCircleViaInvitation(dto, accessToken: accessToken)
            self.authModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            self.authModel.updateUser(user)
            self.transition()
        }
    }
}
