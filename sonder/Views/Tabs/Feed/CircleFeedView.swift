//
//  CircleHomepageView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import SonderDTOs

struct CircleFeedView: View {
    
    @Bindable var authModel: AuthModel
    @State var posts: [PostDTO] = []
    
    var body: some View {
        List {
            ForEach(posts) { post in
                Text("\(post.authorID.uuidString) : \(post.createdAt?.formatted() ?? "createdAt is nil") || \(post.content)")
            }
        }.onAppear {
            Task {
                let controller = CircleFeedViewController(authModel: authModel)
                posts = await controller.fetchPosts()
            }
        }.refreshable {
            let controller = CircleFeedViewController(authModel: authModel)
            posts = await controller.fetchPosts()
        }
    }
}

