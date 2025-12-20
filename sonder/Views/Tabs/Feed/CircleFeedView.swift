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
    var circleFeedVM: CircleFeedViewModel? = nil
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.circleFeedVM = CircleFeedViewModel(authModel: authModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(posts) { post in
                    FeedPostComponent(authModel: authModel, post: post)
                }
            }
        }.onAppear {
            Task {
                posts = await circleFeedVM!.fetchPosts()
            }
        }.refreshable {
            posts = await circleFeedVM!.fetchPosts()
        }
    }
}

