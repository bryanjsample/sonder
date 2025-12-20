//
//  CircleCalendarView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import SonderDTOs

struct CircleCalendarView: View {
    
    @Bindable var authModel: AuthModel
    @State var events: [CalendarEventDTO] = []
    var circleCalendarVM: CircleCalendarViewModel? = nil
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.circleCalendarVM = CircleCalendarViewModel(authModel: authModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(events) { event in
                    FeedEventComponent(authModel: authModel, event: event)
                }
            }
        }.onAppear {
            Task {
                events = await circleCalendarVM!.fetchEvents()
            }
        }.refreshable {
            events = await circleCalendarVM!.fetchEvents()
        }
    }
}
