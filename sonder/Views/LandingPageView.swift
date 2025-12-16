//
//  LandingPageView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

struct LandingPageView: View {
    @Bindable var onboardingModel: OnboardingModel
    @State var tabSelection: LandingPageRoute = .feed
    @State var showingNewPost = false
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Feed", systemImage: "newspaper", value: LandingPageRoute.feed) {
                CircleFeedView()
            }
            Tab("Calendar", systemImage: "calendar", value: LandingPageRoute.calendar) {
                CircleCalendarView()
            }
            Tab("Post", systemImage: "square.and.pencil", value: LandingPageRoute.post) {
                Color.clear
            }
            Tab("Circles", systemImage: "person.3", value: LandingPageRoute.circles) {
                CirclesView()
            }
            Tab("Me", systemImage: "person", value: LandingPageRoute.profile) {
                UserProfileView(onboardingModel: onboardingModel)
            }
        }
        .onChange(of: tabSelection) { oldValue, newValue in
            if newValue == .post {
                showingNewPost = true
                tabSelection = oldValue
            }
        }
        .sheet(isPresented: $showingNewPost) {
            CreateFeedItemView()
        }
    }
}


#Preview {
    LandingPageView(onboardingModel: OnboardingModel())
}
