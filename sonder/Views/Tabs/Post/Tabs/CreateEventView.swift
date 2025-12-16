//
//  CreateEventView.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

struct CreateEventView: View {
    
    @State var createEventVM = CreateEventViewModel()
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                eventForm
                submitButton
            }.ignoresSafeArea(.keyboard)
        }
    }
}

extension CreateEventView {
    
    var eventForm: some View {
        Form {
            Section("Event Details") {
                TextField("Event Title", text: $createEventVM.title)
                TextField("Event Description", text: $createEventVM.description)
                DatePicker("Start Time", selection: $createEventVM.startTime)
                DatePicker("End Time", selection: $createEventVM.endTime)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        GenericButton(title: "Create Event") {
            print("create event")
        }
    }
    
}
