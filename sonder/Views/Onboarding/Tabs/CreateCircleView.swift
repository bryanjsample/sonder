//
//  CreateCircleView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CreateCircleView: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        SonderTitleText.titleBlock
        ProfilePicturePicker(defaultSystemImage: "figure.socialdance.circle.fill")
        circleForm
        submitButton
    }
}

extension CreateCircleView {
    var circleForm: some View {
        Form {
            Section("Circle Information") {
                TextField("Circle Name", text: $name)
                descriptionInput
            }
        }
    }
    
    var descriptionInput: some View {
        ZStack(alignment: .topLeading) {
            if description.isEmpty {
                Text("Circle Description...")
                    .allowsHitTesting(false)
                    .opacity(0.30)
            }
            
            TextEditor(text: $description)
        }
    }
    
    var submitButton: some View {
        Button() {
            print("Created circle")
        } label: {
            Text("Create Circle")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
}

#Preview {
    CreateCircleView()
}
