//
//  CircleHomepageView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import SonderDTOs

struct CircleFeedView: View {
    
    @State var members: [UserDTO] = []
    
    var body: some View {
        List {
            ForEach(members) { member in
                Text("\(member.username ?? "no username yet") || \(member.firstName) \(member.lastName) : \(member.email)")
            }
        }.onAppear {
            Task {
                members = try await self.fetchCircleMembers()
            }
        }
    }
}

extension CircleFeedView {
    // put into a view model and controller to abstract and reduce calls to the server
    func fetchCircleMembers() async throws -> [UserDTO] {
        let tokenController = TokenController()
        let apiClient = DefaultAPIClient()
        let accessToken = try tokenController.loadToken(as: .access)
        let user = try await apiClient.fetchUser(accessToken: accessToken)
        guard let circleID = user.circleID else {
            print("user not in circle")
            throw APIError.notFound
        }
        let members = try await apiClient.fetchCircleUsers(circleID, accessToken: accessToken)
        return members
    }
    
}
