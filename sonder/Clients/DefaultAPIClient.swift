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
    
    private func makeRequest(to url: URL, httpMethod: HttpMethod, accessToken: String?, bodyJSONcontent: Data? = nil, contentType: String = "application/JSON") async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if let content = bodyJSONcontent {
            request.httpBody = try JSONEncoder().encode(content)
        }
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let headers = request.allHTTPHeaderFields {
            print(headers)
        }

        return try await URLSession.shared.data(for: request)
    }
    
    // serverbaseurl/auth/ios POST
    func authenticateViaGoogle(_ googleProfileAPIKey: String) async throws -> TokenResponseDTO? {
        guard let url = self.getURL("/auth/ios") else {
            print("URL is nil in authenticateViaGoogle")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .post, accessToken: googleProfileAPIKey)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse auth google = \(httpResponse)")
        print("auth google status = \(httpResponse.statusCode)")
        
        let tokens = try JSONDecoder().decode(TokenResponseDTO.self, from: data)
        print("PUT SUCCESS: tokens = \(tokens)")
        return tokens
    }
    
//    func requestNewToken() async throws -> TokenResponseDTO // /auth/refresh get
//    func onboardNewUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO? // /auth/onboard POST
    
    // /serverbaseurl/me GET
    func fetchUser(accessToken: TokenStringDTO) async throws -> UserDTO? {
        guard let url = self.getURL("/me") else {
            print("url is nil in fetchUser")
            return nil
        }
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .get, accessToken: accessToken.token)
        
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
    
    // /me PATCH
    func editUser(_ user: UserDTO, accessToken: TokenStringDTO) async throws -> UserDTO? {
        guard let url = self.getURL("/me") else {
            print("url is nil in editUser")
            return nil
        }
        
        let content = try JSONEncoder().encode(user)
        
        let (data, response) = try await self.makeRequest(to: url, httpMethod: .patch, accessToken: accessToken.token, bodyJSONcontent: content)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return nil
        }
        
        print("httpResponse edit user = \(httpResponse)")
        print("edit User status = \(httpResponse.statusCode)")
        
        let user = try JSONDecoder().decode(UserDTO.self, from: data)
        print("PATCH SUCCESS: user = \(user)")
        return user
    }
    
    // /me DELETE
    func deleteUser(accessToken: TokenStringDTO) async throws -> Bool {
        guard let url = self.getURL("/me") else {
            print("url is nil in removeUser ")
            return false
        }
        
        let (_, response) = try await self.makeRequest(to: url, httpMethod: .delete, accessToken: accessToken.token)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("httpResponse is nil")
            return false
        }
        
        print("httpResponse delete user = \(httpResponse)")
        print("delete User status = \(httpResponse.statusCode)")
        
        print("DELETE SUCCESS for user")
        return true
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
        
        print("DELETE SUCCESS for circle event")
        return true
    }

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
