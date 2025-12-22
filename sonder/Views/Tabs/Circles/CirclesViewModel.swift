//
//  CirclesViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

final class CirclesViewModel {
    
    @Bindable var authModel: AuthModel
    let apiClient = DefaultAPIClient()
    let tokenController = TokenController()
    
    init(authModel: AuthModel) { self.authModel = authModel }
    
    func handleFeedItemError(_ error: Error) {
        switch error {
        case APIError.unauthorized:
            print("Unauthorized while attempting to create feed item. Logging out user.")
        case TokenError.tokenDidNotStore:
            print("tokens did not store")
            authModel.unauthenticated()
        case TokenError.tokenDidNotLoad:
            print("tokens did not load")
            authModel.unauthenticated()
        case TokenError.tokenDidNotClear:
            print("tokens did not clear")
            authModel.unauthenticated()
        default:
            print("this error has not been handled within handleFeedItemError")
        }
    }
    
    func getIDs() throws -> (circleID: UUID, userID: UUID) {
        guard let circleID = authModel.circle?.id else {
            print("Trying to create post, but no circle is associated with the authmodel")
            throw FeedItemError.CircleIDMissing
        }
        guard let userID = authModel.user?.id else {
            print("Trying to create post, but no user is associated with the authmodel")
            throw FeedItemError.UserIDMissing
        }
        
        return (circleID: circleID, userID: userID)

    }
    
    func generateCircleInviteCode(on circle : CircleModel) async throws {
        let accessToken = try tokenController.loadToken(as: .access)
        let invitation = try await self.apiClient.createCircleInvitation(accessToken: accessToken)
        circle.updateInvitation(invitation)
    }
    
    func getCircleInvitation(on circle : CircleModel) async throws {
        let accessToken = try tokenController.loadToken(as: .access)
        let invitation = try await self.apiClient.getCircleInvitation(accessToken: accessToken)
        circle.updateInvitation(invitation)
    }
    
//    func fetchCircle() async throws {
//        let accessToken = try tokenController.loadToken(as: .access)
//    }

}
