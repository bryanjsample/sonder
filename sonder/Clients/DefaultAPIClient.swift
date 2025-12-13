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
        let accessToken: String? = nil
        let bodyJSONContent: Data? = nil
        let contentType: String = "application/json; charset=utf-8"
        
        init(url: URL,
             httpMethod: HttpMethod,
             accessToken: String? = nil,
             bodyJSONContent: Data? = nil,
             contentType: String = "application/json; charset=utf-8") {
            self.url = url
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
        let data = try await performAPIAction(model)
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("POST SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
    // /auth/refresh POST (USE WHEN ACCESS TOKEN IS EXPIRED)
    func requestNewAccessToken(refreshToken: TokenStringDTO) async throws -> TokenResponseDTO {
        let url = try self.getURL("/auth/refresh")
        let content = try JSONEncoder().encode(refreshToken)
        let model = RequestModel(url: url, httpMethod: .post, bodyJSONContent: content)
        let data = try await performAPIAction(model)
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("POST SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
    // /serverbaseurl/me GET
    func fetchUser(accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me")
        let model = RequestModel(url: url, httpMethod: .get, accessToken: accessToken.token)
        let data = try await performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("GET SUCCESS: user = \(user)")
        return user
    }
    
    // /me PATCH
    func editUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me")
        let content = try JSONEncoder().encode(user)
        let model = RequestModel(url: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("PATCH SUCCESS: user = \(user)")
        return user
    }
    
    // /me DELETE
    func deleteUser(accessToken: TokenStringDTO) async throws {
        let url = try self.getURL("/me")
        let model = RequestModel(url: url, httpMethod: .delete)
        let _ = try await performAPIAction(model)
        print("DELETE SUCCESS for user")
    }
    
    // /me/onboard POST
    func onboardNewUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO {
        let url = try self.getURL("/me/onboard")
        let content = try JSONEncoder().encode(user)
        let model = RequestModel(url: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONContent: content)
        let data = try await performAPIAction(model)
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("POST SUCCESS user = \(user)")
        return user
    }
    
    // /me/events get
    func fetchUserEvents(accessToken: TokenStringDTO) async throws -> [CalendarEventDTO]? {
        guard let url = self.getURL("/me/events") else {
            print("url is empty in fetchUserEvents")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchUserEvents = \(httpResponse)")
        print("fetchUserEvents status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let events = try JSONDecoder().decode(([CalendarEventDTO].self), from: data)
        print("GET SUCCESS events = \(events)")
        return events
    }
    
    // /me/posts get
    func fetchUserPosts(accessToken: TokenStringDTO) async throws -> [PostDTO]? {
        guard let url = self.getURL("/me/posts") else {
            print("url is empty in fetchUserPosts")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchUserPosts = \(httpResponse)")
        print("fetchUserPosts status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let posts = try JSONDecoder().decode([PostDTO].self, from: data)
        print("GET SUCCESS posts = \(posts)")
        return posts
    }
    
    // /circles post
    func createCircle(_ circle: CircleDTO, accessToken: TokenStringDTO) async throws -> CircleDTO? {
        guard let url = self.getURL("/circles") else {
            print("url is empty in createCircle")
            return nil
        }
        
        let content = try JSONEncoder().encode(circle)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse createCircle = \(httpResponse)")
        print("createCircle status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("POST SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/invitation POST
    func joinCircleViaInvitation(_ invitationCode: InvitationStringDTO, accessToken: TokenStringDTO) async throws -> CircleDTO? {
        guard let url = self.getURL("/circles/invitation") else {
            print("url is nil in joinCircleViaInvitation")
            return nil
        }
        
        let content = try JSONEncoder().encode(invitationCode)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse joinCircleViaInvitation = \(httpResponse)")
        print("joinCircleViaInvitation status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("POST SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID GET
    func fetchCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)") else {
            print("url is nil in fetchCircle")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCircle = \(httpResponse)")
        print("fetchCircle status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("GET SUCCES circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID PATCH
    func editCircle(_ circle: CircleDTO, circleID: UUID, accessToken: TokenStringDTO) async throws -> CircleDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)") else {
            print("url is nil in editCircle")
            return nil
        }
        
        let content = try JSONEncoder().encode(circle)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse editCircle = \(httpResponse)")
        print("editCircle status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let circle = try JSONDecoder().decode(CircleDTO.self, from: data)
        print("PATCH SUCCESS circle = \(circle)")
        return circle
    }
    
    // /circles/:circleID DELETE
    func deleteCircle(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> Bool {
        guard let url = self.getURL("/circles/:circleID") else {
            print("url is nil in deleteCircle ")
            return false
        }
        
        let (_, response) = try await self.makeRequest(to: url, httpMethod: .delete, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return false
        }
        
        print("httpResponse delete circle = \(httpResponse)")
        print("delete circle status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        print("DELETE SUCCESS for circle")
        return true
    }

    // /circles/:circleID/users GET
    func fetchCircleUsers(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [UserDTO]? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/users") else {
            print("url is nil in fetchCircleUsers")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCircleUsers = \(httpResponse)")
        print("fetchCircleUsers status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let users = try JSONDecoder().decode([UserDTO].self, from: data)
        print("GET SUCCESS circle users = \(users)")
        return users
    }
    
    // /circles/:circleID/feed GET
    func fetchCircleFeed(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> FeedResponseDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/feed") else {
            print("url is nil in fetchCircleFeed")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCircleFeed = \(httpResponse)")
        print("fetchCircleFeed status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let feed = try JSONDecoder().decode(FeedResponseDTO.self, from: data)
        print("GET SUCCESS feed = \(feed)")
        return feed
    }
   
    // /cicles/:circleID/events GET
    func fetchCircleEvents(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [CalendarEventDTO]? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/events") else {
            print("url is nil in fetchCircleEvents")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCircleEvents = \(httpResponse)")
        print("fetchCircleEvents status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let events = try JSONDecoder().decode([CalendarEventDTO].self, from: data)
        print("GET SUCCESS circle events = \(events)")
        return events
    }
    
    // /circles/:circleID/events POST
    func createCircleEvent(_ circleID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/events") else {
            print("url is nil in createCircleEvent")
            return nil
        }
        
        let content = try JSONEncoder().encode(event)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse createCircleEvent = \(httpResponse)")
        print("createCircleEvent status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("POST SUCCESS event = \(event)")
        return event
    }
    
    // /circles/:circleID/events/:eventID GET
    func fetchCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws -> CalendarEventDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)") else {
            print("url is nil in fetchCircleEvent")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCircleEvent = \(httpResponse)")
        print("fetchCircleEvent status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("GET SUCCESS event = \(event)")
        return event
    }
    
    // /circles/:circleID/events/:eventID PATCH
    func editCircleEvent(circleID: UUID, eventID: UUID, event: CalendarEventDTO, accessToken: TokenStringDTO) async throws -> CalendarEventDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)") else {
            print("url is nil in editCircleEvent")
            return nil
        }
        
        let content = try JSONEncoder().encode(event)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse editCircleEvent = \(httpResponse)")
        print("editCircleEvent status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let event = try JSONDecoder().decode(CalendarEventDTO.self, from: data)
        print("PATCH SUCCESS event = \(event)")
        return event
    }

    // /circles/:circleID/events/:eventID DELETE
    func deleteCircleEvent(circleID: UUID, eventID: UUID, accessToken: TokenStringDTO) async throws -> Bool {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/events/\(eventID.uuidString)") else {
            print("url is nil in deletCircleEvent")
            return false
        }
        
        let (_, response) = try await self.makeRequest(to: url, httpMethod: .delete, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return false
        }
        
        print("httpResponse editCircleEvent = \(httpResponse)")
        print("editCircleEvent status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        print("DELETE SUCCESS for circle event")
        return true
    }

    // /circles/:circleID/posts GET
    func fetchCirclePosts(_ circleID: UUID, accessToken: TokenStringDTO) async throws -> [PostDTO]? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts") else {
            print("url is nil in fetchCirclePosts")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCirclePosts = \(httpResponse)")
        print("fetchCirclePosts status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let posts = try JSONDecoder().decode([PostDTO].self, from: data)
        print("GET SUCCESS circle posts = \(posts)")
        return posts
    }

    // /circles/:circleID/posts POST
    func createCirclePost(_ circleID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts") else {
            print("url is nil in createCirclePost")
            return nil
        }
        
        let content = try JSONEncoder().encode(post)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse createCirclePost = \(httpResponse)")
        print("createCirclePost status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("POST SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID GET
    func fetchCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> PostDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/post/\(postID.uuidString)") else {
            print("url is nil in fetchCirclePost")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchCirclePost = \(httpResponse)")
        print("fetchCirclePost status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("GET SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID PATCH
    func editCirclePost(circleID: UUID, postID: UUID, post: PostDTO, accessToken: TokenStringDTO) async throws -> PostDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/post/\(postID.uuidString)") else {
            print("url is nil in editCirclePost")
            return nil
        }
        
        let content = try JSONEncoder().encode(post)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse editCirclePost = \(httpResponse)")
        print("editCirclePost status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()

        let post = try JSONDecoder().decode(PostDTO.self, from: data)
        print("PATCH SUCCESS circle post = \(post)")
        return post
    }
    
    // /circles/:circleID/posts/:postID delete
    func deleteCirclePost(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> Bool {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)") else {
            print("url is nil in deleteCirclePost")
            return false
        }
        
        let (_, response) = try await self.makeRequest(to: url, httpMethod: .delete, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return false
        }
        
        print("httpResponse deleteCirclePost = \(httpResponse)")
        print("deleteCirclePost status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        print("DELETE SUCCESS for circle post")
        return true
    }

    // /circles/:circleID/posts/:postID/comments GET
    func fetchPostComments(circleID: UUID, postID: UUID, accessToken: TokenStringDTO) async throws -> [CommentDTO]? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments") else {
            print("url is nil in fetchPostComments")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchPostComments = \(httpResponse)")
        print("fetchPostComments status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let comments = try JSONDecoder().decode([CommentDTO].self, from: data)
        print("GET SUCCESS post comments = \(comments)")
        return comments
    }
    
    // /circles/:circleID/posts/:postID/comments POST
    func createPostComment(circleID: UUID, postID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments") else {
            print("url is nil in createPostComment")
            return nil
        }
        
        let content = try JSONEncoder().encode(comment)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse createPostComment = \(httpResponse)")
        print("createPostComment status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("POST SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID GET
    func fetchPostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws -> CommentDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)") else {
            print("url is nil in fetchPostComment")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse fetchPostComment = \(httpResponse)")
        print("fetchPostComment status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("GET SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID PATCH
    func editPostComment(circleID: UUID, postID: UUID, commentID: UUID, comment: CommentDTO, accessToken: TokenStringDTO) async throws -> CommentDTO? {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)") else {
            print("url is nil in editPostComment")
            return nil
        }
        
        let content = try JSONEncoder().encode(comment)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse editPostComment = \(httpResponse)")
        print("editPostComment status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        let comment = try JSONDecoder().decode(CommentDTO.self, from: data)
        print("PATCH SUCCESS post comment = \(comment)")
        return comment
    }
    
    // /circles/:circleID/posts/:postID/comments/:commentID delete
    func deletePostComment(circleID: UUID, postID: UUID, commentID: UUID, accessToken: TokenStringDTO) async throws -> Bool {
        guard let url = self.getURL("/circles/\(circleID.uuidString)/posts/\(postID.uuidString)/comments/\(commentID.uuidString)") else {
            print("url is nil in deletePostComment")
            return false
        }
        
        let (_, response) = try await self.makeRequest(to: url, httpMethod: .delete, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return false
        }
        
        print("httpResponse editPostComment = \(httpResponse)")
        print("editPostComment status = \(httpResponse.statusCode)")
        
        try httpResponse.propagateError()
        
        print("DELETE SUCCESS on post comment")
        return true
    }
}
