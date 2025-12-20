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
    @State var feedItems: [FeedItemDTO] = []
    var circleFeedVM: CircleFeedViewModel? = nil
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.circleFeedVM = CircleFeedViewModel(authModel: authModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(feedItems) { item in
                    switch item {
                    case .post(let post):
                        FeedPostComponent(authModel: authModel, post: post)
                    case .event(let event):
                        FeedEventComponent(authModel: authModel, event: event)
                    }
                    
                }
            }
        }.onAppear {
            Task {
                feedItems = await circleFeedVM!.fetchFeedItems()
            }
        }.refreshable {
            feedItems = await circleFeedVM!.fetchFeedItems()
        }
    }
}

