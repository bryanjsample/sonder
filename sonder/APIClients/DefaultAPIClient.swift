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
    
    private enum HttpMethod: Equatable {
        case get, post, patch, put, delete
        
        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            }
        }
    }
    
    private func getURL(_ endpoint: String) throws -> URL {
        guard let serverBaseURL = ProcessInfo.processInfo.environment["SERVER_BASE_URL"] else {
            print("Server base URL is not defined")
            throw APIError.undefinedServerBaseURL
        }
        
        let urlString = serverBaseURL + endpoint
        print("request url = \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw APIError.invalidURL
        }
        return url
    }
    
    private struct RequestModel {
        let url: URL
        let httpMethod: HttpMethod
        var accessToken: String?
        var bodyJSONContent: Data?
        var contentType: String
        
        init(url: URL,
             httpMethod: HttpMethod,
             accessToken: String? = nil,
             bodyJSONContent: Data? = nil,
             contentType: String = "application/json; charset=utf-8") {
            self.url = url
            self.httpMethod = httpMethod
            self.accessToken = accessToken
            self.bodyJSONContent = bodyJSONContent
            self.contentType = contentType
        }
    }
    
    private func makeRequest(_ model: RequestModel) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: model.url)
        request.httpMethod = model.httpMethod.description
        request.setValue(model.contentType, forHTTPHeaderField: "Content-Type")
        if let content = model.bodyJSONContent {
            request.httpBody = content
        }
        if let token = model.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let headers = request.allHTTPHeaderFields {
            print(headers)
        }

        return try await URLSession.shared.data(for: request)
    }
    
    private func performAPIAction(_ model: RequestModel) async throws -> Data {
        let (data, response) = try await self.makeRequest(model)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            throw APIError.invalidResponse
        }
        
        print("httpResponse = \(httpResponse)")
        print("status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        return data
    }
    
    // serverbaseurl/auth/ios POST
    func authenticateViaGoogle(_ googleProfileAPIKey: String) async throws -> TokenResponseDTO {
        let url = try self.getURL("/auth/ios")
        let model = RequestModel(url: url, httpMethod: .post, accessToken: googleProfileAPIKey)
        let data = try await self.performAPIAction(model)
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("POST SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
    // /auth/refresh POST (USE WHEN ACCESS TOKEN IS EXPIRED)
    func requestNewAccessToken(refreshToken: TokenStringDTO) async throws -> TokenResponseDTO {
        let url = try self.getURL("/auth/refresh")
        let content = try JSONEncoder().encode(refreshToken)
        let model = RequestModel(url: url, httpMethod: .post, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("POST SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
    // /serverbaseurl/me GET
    func fetchUser(accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("GET SUCCESS: user = \(user)")
        return user
    }
    
    // /me PATCH
    func editUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me")
        let content = try JSONEncoder().encode(user)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("PATCH SUCCESS: user = \(user)")
        return user
    }
    
    // /me DELETE
    func deleteUser(accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/me")
        let model = RequestModel(url: url, httpMethod: .delete)
        let _ = try await self.performAPIAction(model)
        print("DELETE SUCCESS for user")
    }
    
    // /me/onboard POST
    func onboardNewUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me/onboard")
        let content = try JSONEncoder().encode(user)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("POST SUCCESS user = \(user)")
        return user
    }
    
    // /me/events get
    func fetchUserEvents(accessToken: TokenStringDTO) async throws -> [CalendarEventDTO] {
        let url = try self.getURL("/me/events")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let events = try JSONDecoder().decode(([CalendarEventDTO].self), from: data)
        print("GET SUCCESS events = \(events)")
        return events
    }
    
    // /me/posts get
    func fetchUserPosts(accessToken: TokenStringDTO) async throws -> [PostDTO] {
        let url = try self.getURL("/me/posts")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let posts = try JSONDecoder().decode([PostDTO].self, from: data)
        print("GET SUCCESS posts = \(posts)")
        return posts
    }
    
    // /circles post
    func createCircle(_ circle: CircleDTO, accessToken: TokenStringDTO) async throws -> CircleDTO {
        let url = try self.getURL("/circles")
        let content = try JSONEncoder().encode(circle)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("POST SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/invitation/create POST
    func createCircleInvitation(accessToken: TokenStringDTO) async throws -> CircleInvitationDTO {
        let url = try self.getURL("/circles/invitation/create")
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let circleInvite = try JSONDecoder().decode(CircleInvitationDTO.self, from: data)
        print("POST SUCCESS circleInviteCode = \(circleInvite)")
        return circleInvite
    }
    
    // /circles/invitation/join POST
    func joinCircleViaInvitation(_ invitationCode: InvitationStringDTO, accessToken: TokenStringDTO) async throws -> CircleDTO {
        let url = try self.getURL("/circles/invitation/join")
        let content = try JSONEncoder().encode(invitationCode)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("POST SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID GET
    func fetchCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("GET SUCCES circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID PATCH
    func editCircle(_ circle: CircleDTO, circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)")
        let content = try JSONEncoder().encode(circle)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("PATCH SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID DELETE
    func deleteCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/circles/:circleID")
        let model = RequestModel(url: url, httpMethod: .delete, accessToken: accessToken.token)
        let _ = try await self.performAPIAction(model)
        print("DELETE SUCCESS for circle")
    }

    // /circles/:circleID/users GET
    func fetchCircleUsers(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [UserDTO] {
        let url = try self.getURL("/circles/\(circleID.uuidString)/users")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let users = try JSONDecoder().decode([UserDTO].self, from: data)
        print("GET SUCCESS circle users = \(users)")
        return users
    }
    
    // /circles/:circleID/feed GET
    func fetchCircleFeed(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> FeedResponseDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/feed")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let feed = try JSONDecoder().decode(FeedResponseDTO.self, from: data)
        print("GET SUCCESS feed = \(feed)")
        return feed
    }
   
    // /cicles/:circleID/events GET
    func fetchCircleEvents(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [CalendarEventDTO] {
        let url = try self.getURL("/circles/\(circleID.uuidString)/events")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let events = try JSONDecoder().decode([CalendarEventDTO].self, from: data)
        print("GET SUCCESS circle events = \(events)")
        return events
    }
    
    // /circles/:circleID/events POST
    func createCircleEvent(_ circleID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/events")
        let content = try JSONEncoder().encode(event)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("POST SUCCESS event = \(event)")
        return event
    }
    
    // /circles/:circleID/events/:eventID GET
    func fetchCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws -> CalendarEventDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("GET SUCCESS event = \(event)")
        return event
    }
    
    // /circles/:circleID/events/:eventID PATCH
    func editCircleEvent(circleID: UUID, eventID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)")
        let content = try JSONEncoder().encode(event)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await performAPIAction(model)
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("PATCH SUCCESS event = \(event)")
        return event
    }

    // /circles/:circleID/events/:eventID DELETE
    func deleteCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .delete, accessToken: accessToken.token)
        let _ = try await self.performAPIAction(model)
        print("DELETE SUCCESS for circle event")
    }

    // /circles/:circleID/posts GET
    func fetchCirclePosts(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [PostDTO] {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let posts = try JSONDecoder().decode([PostDTO].self, from: data)
        print("GET SUCCESS circle posts = \(posts)")
        return posts
    }

    // /circles/:circleID/posts POST
    func createCirclePost(_ circleID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts")
        let content = try JSONEncoder().encode(post)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("POST SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID GET
    func fetchCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> PostDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/post/\(postID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("GET SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID PATCH
    func editCirclePost(circleID: UUID, postID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/post/\(postID.uuidString)")
        let content = try JSONEncoder().encode(post)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("PATCH SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID delete
    func deleteCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .delete, accessToken: accessToken.token)
        let _ = try await self.performAPIAction(model)
        print("DELETE SUCCESS for circle post")
    }

    // /circles/:circleID/posts/:postID/comments GET
    func fetchPostComments(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> [CommentDTO] {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let comments = try JSONDecoder().decode([CommentDTO].self, from: data)
        print("GET SUCCESS post comments = \(comments)")
        return comments
    }
    
    // /circles/:circleID/posts/:postID/comments POST
    func createPostComment(circleID: UUID, postID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments")
        let content = try JSONEncoder().encode(comment)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("POST SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID GET
    func fetchPostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws -> CommentDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await self.performAPIAction(model)
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("GET SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID PATCH
    func editPostComment(circleID: UUID, postID: UUID, commentID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)")
        let content = try JSONEncoder().encode(comment)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await self.performAPIAction(model)
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("PATCH SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID delete
    func deletePostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)")
        let model = RequestModel(url: url, httpMethod: .delete, accessToken: accessToken.token)
        let _ = try await self.performAPIAction(model)
        print("DELETE SUCCESS on post comment")
    }
}
