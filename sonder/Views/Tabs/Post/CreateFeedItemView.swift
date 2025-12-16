//
//  CreateFeedItemView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct CreateFeedItemView: View {
    
    @State var tabSelection: CircleFeedItemRoute = .post
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Post", systemImage: "square.and.pencil", value: .post) {
                CreatePostView()
            }
            Tab("Event", systemImage: "calendar", value: .event) {
                CreateEventView()
            }
        }
    }
}
