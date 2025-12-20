//
//  FeedPostComponentViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/19/25.
//

import SwiftUI
import SonderDTOs

final class FeedPostComponentViewModel {
    
    @Bindable var authModel: AuthModel
    let apiClient = DefaultAPIClient()
    let tokenController = TokenController()
    
    init(authModel: AuthModel) { self.authModel = authModel }
    
    func handlePostComponentError(_ error: Error) {
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
            print("this error has not been handled within handlePostComponentError : \(error)")
        }
    }
    
    @MainActor
    func runFeedPostComponentFlow(_ operation: @escaping () async throws -> Void) {
        Task {
            do {
                try await operation()
            } catch {
                self.handlePostComponentError(error)
            }
        }
    }
    
    func fetchAuthor(_ post: PostDTO) async throws -> UserDTO {
        var author: UserDTO? = nil
        do {
            let accessToken = try self.tokenController.loadToken(as: .access)
            author = try await self.apiClient.fetchCircleUser(circleID: post.circleID, userID: post.authorID, accessToken: accessToken)
        } catch {
            self.handlePostComponentError(error)
        }
        guard let author else {
            throw APIError.notFound
        }
        return author
    }
    
    func getAuthorName(_ author: UserDTO?) -> String {
        let firstName = author?.firstName ?? "no first name"
        let lastName = author?.lastName ?? "no last name"
        return "\(firstName) \(lastName)"
    }
    
    func getAuthorUsername(_ author: UserDTO?) -> String {
        author?.username ?? "no username"
    }
}
