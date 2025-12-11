//
//  DefaultAPIClient.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SonderDTOs
import Foundation
import GoogleSignIn

final class DefaultAPIClient: APIClient {
    
    private func getURL(_ endpoint: String) -> URL? {
        guard let serverBaseURL = ProcessInfo.processInfo.environment["SERVER_BASE_URL"] else {
            print("Server base URL is not defined")
            return nil
        }
        let urlString = serverBaseURL + endpoint
        print("request url = \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }
        return url
    }
    
    // serverbaseurl/auth/ios POST
    func authenticateViaGoogle(_ googleProfileAPIKey: String) async throws -> TokenResponseDTO? {
        guard let url = self.getURL("/auth/ios") else {
            print("URL is nil in authenticateViaGoogle")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(googleProfileAPIKey)", forHTTPHeaderField: "Authorization")
        
        print(request.allHTTPHeaderFields)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
            print("httpResponse = \(httpResponse)")
            print("status = \(httpResponse.statusCode)")
        }
        
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("POST SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
//    func requestNewToken() async throws -> TokenResponseDTO // /auth/refresh get
//
    
    // /serverbaseurl/me GET
    func fetchUser(_ accessToken: TokenStringDTO) async throws -> UserDTO? {
        guard let url = self.getURL("/me") else {
            print("user is nil is fetcUser")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetch user = \(httpResponse)")
        print("fetchUser status = \(httpResponse.statusCode)")
        
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("GET SUCCESS: user = \(user)")
        return user
    }
    
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
