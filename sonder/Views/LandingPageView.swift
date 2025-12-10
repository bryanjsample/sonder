//
//  LandingPageView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

struct LandingPageView: View {
    @State var tabSelection: TabRoute = .feed
    @Bindable var authVM: AuthViewModel
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Feed", systemImage: "newspaper", value: .feed) {
                CircleFeedView()
            }
            Tab("Calendar", systemImage: "calendar", value: .calendar) {
                CircleCalendarView()
            }
            Tab("Post", systemImage: "square.and.pencil", value: .post) {
                CreateFeedItemView()
            }
            Tab("Circles", systemImage: "person.3", value: .circles) {
                CirclesView()
            }
            Tab("Me", systemImage: "person", value: .profile) {
                UserProfileView()
            }
        }
    }
}

#Preview {
    LandingPageView(authVM: AuthViewModel())
}
