//
//  CreateFeedItemView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

enum CreateFeedItemRoute {
    case post, event
}

struct CreateFeedItemView: View {
    
    @Bindable var authModel: AuthModel
    @State var tabSelection: CreateFeedItemRoute = .post
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Post", systemImage: "square.and.pencil", value: .post) {
                CreatePostView(authModel: authModel)
            }
            Tab("Event", systemImage: "calendar", value: .event) {
                CreateEventView(authModel: authModel)
            }
        }
    }
}
