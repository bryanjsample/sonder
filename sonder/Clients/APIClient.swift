//
//  APIClient.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SonderDTOs
import Foundation

protocol APIClient {
    func authenticateViaGoogle(_ googleProfileAPIKey: String) async throws -> TokenResponseDTO? // /auth/ios POST
//    func requestNewToken() async throws -> TokenResponseDTO // /auth/refresh get
//
    func fetchUser(_ accessToken: TokenStringDTO) async throws -> UserDTO? // /me get
//    func editUser(_ user: UserDTO) async throws -> UserDTO // /me patch
//    func removeUser() async throws // /me delete
//    func fetchUserEvents() async throws -> [CalendarEventDTO] // /me/events get
//    func fetchUserPosts() async throws -> [PostDTO] // /me/posts get
//    
//    func createCircle(_ circle: CircleDTO) async throws -> CircleDTO // /circles post
//    func fetchCircle(_ circleID: UUID) async throws -> CircleDTO // /circles/:circleID get
//    func editCircle(_ circle: CircleDTO) async throws -> CircleDTO // /circles/:circleID patch
//    func deleteCircle(_ circleID: UUID) async throws // /circles/:circleID delete
//    func fetchCircleUsers(_ circleID: UUID) async throws -> [UserDTO] // /circles/:circleID/users get
//    func fetchCircleFeed(_ circleID: UUID) async throws -> FeedResponseDTO // /circles/:circleID/feed get
//    
//    func fetchCircleEvents(_ circleID: UUID) async throws -> [CalendarEventDTO] // /circles:circleID/events get
//    func createCircleEvent(_ circleID: UUID, event: CalendarEventDTO) -> CalendarEventDTO // /circles/:circleID/events post
//    func fetchCircleEvent(circleID: UUID, eventID: UUID) async throws -> CalendarEventDTO // /circles:circleID/events/:eventID get
//    func editCircleEvent(circleID: UUID, eventID: UUID, event: CalendarEventDTO) async throws -> CalendarEventDTO // /circles/:circleID/events/:eventID patch
//    func deleteCircleEvent(circleID: UUID, eventID: UUID) async throws // /circles/:circleID/events/:eventID delete
//    
//    func fetchCirclePosts(_ circleID: UUID) async throws -> [PostDTO] // /circles/:circleID/posts get
//    func createCirclePost(_ circleID: UUID, post: PostDTO) async throws -> PostDTO // /circles/:circleID/posts post
//    func fetchCirclePost(circleID: UUID, postID: UUID) async throws -> PostDTO // /circles/:circleID/posts/:postID get
//    func editCirclePost(circleID: UUID, postID: UUID, post: PostDTO) async throws -> PostDTO // /circles/:circleID/posts/:postID patch
//    func deleteCirclePost(circleID: UUID, postID: UUID) async throws // /circles/:circleID/posts/:postID delete
//    
//    func fetchPostComments(circleID: UUID, postID: UUID) async throws -> [CommentDTO] // /circles/:circleID/posts/:postID/comments get
//    func createPostComment(circleID: UUID, postID: UUID, comment: CommentDTO) async throws -> CommentDTO // /circles/:circleID/posts/:postID/comments post
//    func fetchPostComment(circleID: UUID, postID: UUID, commentID: UUID) async throws -> CommentDTO // /circles/:circleID/posts/:postID/comments/:commentID get
//    func editPostComment(circleID: UUID, postID: UUID, commentID: UUID, comment: CommentDTO) async throws -> CommentDTO // /circles/:circleID/posts/:postID/comments/:commentID patch
//    func deletePostComment(circleID: UUID, postID: UUID, commentID: UUID) async throws // /circles/:circleID/posts/:postID/comments/:commentID delete
}

