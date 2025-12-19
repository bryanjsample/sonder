//
//  CreateEventView.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

struct CreateEventView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var authModel: AuthModel
    @State var createEventVM: CreateFeedItemViewModel
    @State var title: String = ""
    @State var description: String = ""
    @State var startTime: Date = Date.now
    @State var endTime: Date = Date.now.adding(hours: 1) ?? Date.now
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.createEventVM = CreateFeedItemViewModel(authModel: authModel) // this is not the same object as self.authModel after init finishes ??? test this
    }
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                Form {
                    Section("Event Details") {
                        TextField("Event Title", text: $title)
                        TextField("Event Description", text: $description)
                        DatePicker("Start Time", selection: $startTime)
                        DatePicker("End Time", selection: $endTime)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                .scrollContentBackground(.hidden)
                submitButton
            }.ignoresSafeArea(.keyboard)
        }
    }
}

extension CreateEventView {
    
    var submitButton: some View {
        GenericButton(title: "Create Event") {
            createEventVM.createNewEvent(title: title, description: description, startTime: startTime, endTime: endTime)
            dismiss()
        }
    }
    
}
