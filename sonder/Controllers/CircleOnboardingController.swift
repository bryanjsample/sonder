//
//  CircleOnboardingController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import Foundation
import SonderDTOs

extension OnboardingController {
    func onboardNewCircle(with onboardingModel: OnboardingModel, circleName: String, description: String) {
        self.runOnboardingFlow(with: onboardingModel) {
            let dto = CircleDTO(name: circleName, description: description)
            onboardingModel.updateCircle(dto) // update within model to ensure that fields stay populated even if onboarding fails on server
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.createCircle(dto, accessToken: accessToken)
            onboardingModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            onboardingModel.updateUser(user)
            self.transition(with: onboardingModel)
        }
    }
    
    func joinCircleViaCode(with onboardingModel: OnboardingModel, invitation: String) {
        self.runOnboardingFlow(with: onboardingModel) {
            let dto = InvitationStringDTO(invitation)
            let tokenController = TokenController()
            let accessToken = try tokenController.loadToken(as: .access)
            let circle = try await self.apiClient.joinCircleViaInvitation(dto, accessToken: accessToken)
            onboardingModel.updateCircle(circle)
            let user = try await self.apiClient.fetchUser(accessToken: accessToken)
            onboardingModel.updateUser(user)
            self.transition(with: onboardingModel)
        }
    }
}
