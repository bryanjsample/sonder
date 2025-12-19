//
//  CreateFeedItemViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

final class CreateFeedItemViewModel {
    
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
            print("this error has not been handled within handleFeedItemError : \(error)")
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
    
    @MainActor
    func runFeedItemCreationFlow(_ operation: @escaping () async throws -> Void) {
        Task {
            do {
                try await operation()
            } catch {
                self.handleFeedItemError(error)
            }
        }
    }
    
    @MainActor
    func createNewPost(_ postContent: String) {
        self.runFeedItemCreationFlow {
            let (circleID, userID) = try self.getIDs()
            let dto = PostDTO(circleID: circleID, authorID: userID, content: postContent)
            let accessToken = try self.tokenController.loadToken(as: .access)
            let post = try await self.apiClient.createCirclePost(circleID, post: dto, accessToken: accessToken)
            print("in view model post = \(post)")
        }
    }
    
    @MainActor
    func createNewEvent(title: String, description: String, startTime: Date, endTime: Date) {
        self.runFeedItemCreationFlow {
            let (circleID, userID) = try self.getIDs()
            let dto = CalendarEventDTO(hostID: userID, circleID: circleID, title: title, description: description, startTime: startTime, endTime: endTime)
            print("before request: dto = \(dto)")
            let accessToken = try self.tokenController.loadToken(as: .access)
            let event = try await self.apiClient.createCircleEvent(circleID, event: dto, accessToken: accessToken)
            print("in view model post = \(event)")
        }
    }
}
