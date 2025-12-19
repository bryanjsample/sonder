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
    
    var body: some View {
        List {
            ForEach(events) { event in
                Text("\(event.hostID.uuidString) : \(event.createdAt?.formatted() ?? "createdAt is nil") || start = \(event.startTime) | end = \(event.endTime) || title = \(event.title) | desc = \(event.description)")
            }
        }.onAppear {
            Task {
                let controller = CircleCalendarViewController(authModel: authModel)
                events = await controller.fetchEvents()
            }
        }.refreshable {
            let controller = CircleCalendarViewController(authModel: authModel)
            events = await controller.fetchEvents()
        }
    }
}
