//
//  LandingPageView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

enum LandingPageRoute {
    case feed, calendar, post, circles, profile
}

struct LandingPageView: View {
    @Bindable var authModel: AuthModel
    @State var tabSelection: LandingPageRoute = .feed
    @State var showingNewPost = false
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Feed", systemImage: "newspaper", value: LandingPageRoute.feed) {
                CircleFeedView(authModel: authModel)
            }
            Tab("Calendar", systemImage: "calendar", value: LandingPageRoute.calendar) {
                CircleCalendarView(authModel: authModel)
            }
            Tab("Post", systemImage: "square.and.pencil", value: LandingPageRoute.post) {
                Color.clear
            }
            Tab("Circles", systemImage: "person.3", value: LandingPageRoute.circles) {
                CirclesView(authModel: authModel)
            }
            Tab("Me", systemImage: "person", value: LandingPageRoute.profile) {
                UserProfileView(authModel: authModel)
            }
        }
        .onChange(of: tabSelection) { oldValue, newValue in
            if newValue == .post {
                showingNewPost = true
                tabSelection = oldValue
            }
        }
        .sheet(isPresented: $showingNewPost) {
            CreateFeedItemView(authModel: authModel)
        }
    }
}


#Preview {
    LandingPageView(authModel: AuthModel())
}
