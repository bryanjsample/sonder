//
//  APIClient.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SonderDTOs
import Foundation

protocol APIClient {
    // /auth/ios POST
    func authenticateViaGoogle(_ googleProfileAPIKey: String) async throws -> TokenResponseDTO?
    // /auth/refresh get
//    func requestNewToken() async throws -> TokenResponseDTO
    // /auth/onboard POST
//    func onboardNewUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO?
    
    // /me GET
    func fetchUser(accessToken: TokenStringDTO) async throws -> UserDTO?
    // /me PATCH
    func editUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO?
    // /me DELETE
    func deleteUser(accessToken: TokenStringDTO) async throws -> Bool
    // /me/events GET
    func fetchUserEvents(accessToken: TokenStringDTO) async throws -> [CalendarEventDTO]?
    // /me/posts GET
    func fetchUserPosts(accessToken: TokenStringDTO) async throws -> [PostDTO]?

    // /circles POST
    func createCircle(_ circle: CircleDTO, accessToken: TokenStringDTO) async throws -> CircleDTO?
    // /circles/:circleID GET
    func fetchCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO?
    // /circles/:circleID PATCH
    func editCircle(_ circle: CircleDTO, circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO?
    // /circles/:circleID DELETE
    func deleteCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> Bool
    // /circles/:circleID/users GET
    func fetchCircleUsers(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [UserDTO]?
    // /circles/:circleID/feed GET
    func fetchCircleFeed(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> FeedResponseDTO?

    // /circles/:circleID/events GET
    func fetchCircleEvents(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [CalendarEventDTO]?
    // /circles/:circleID/events POST
    func createCircleEvent(_ circleID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO?
    // /circles:circleID/events/:eventID GET
    func fetchCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws -> CalendarEventDTO?
    // /circles/:circleID/events/:eventID PATCH
    func editCircleEvent(circleID: UUID, eventID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO?
    // /circles/:circleID/events/:eventID DELETE
    func deleteCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws -> Bool
    
    // /circles/:circleID/posts GET
    func fetchCirclePosts(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [PostDTO]?
    // /circles/:circleID/posts POST
    func createCirclePost(_ circleID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO?
    // /circles/:circleID/posts/:postID GET
    func fetchCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> PostDTO?
    // /circles/:circleID/posts/:postID PATCH
    func editCirclePost(circleID: UUID, postID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO?
    // /circles/:circleID/posts/:postID delete
    func deleteCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> Bool

    // /circles/:circleID/posts/:postID/comments GET
    func fetchPostComments(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> [CommentDTO]?
    // /circles/:circleID/posts/:postID/comments POST
    func createPostComment(circleID: UUID, postID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO?
    // /circles/:circleID/posts/:postID/comments/:commentID GET
    func fetchPostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws -> CommentDTO?
    // /circles/:circleID/posts/:postID/comments/:commentID PATCH
    func editPostComment(circleID: UUID, postID: UUID, commentID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO?
    // /circles/:circleID/posts/:postID/comments/:commentID delete
    func deletePostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws -> Bool
}

