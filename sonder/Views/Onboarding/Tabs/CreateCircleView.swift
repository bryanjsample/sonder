//
//  CreateCircleView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CreateCircleView: View {
    
    @Bindable var onboardingModel: OnboardingModel
    @State private var name: String = ""
    @State private var description: String = ""
    @FocusState private var isFocused: Bool
    
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
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    }
    
    var descriptionInput: some View {
        ZStack(alignment: .topLeading) {
            if !isFocused && description.isEmpty {
                Text("Circle Description...")
                    .allowsHitTesting(false)
                    .opacity(0.30)
            }
            
            TextEditor(text: $description)
                .focused($isFocused)
        }
    }
    
    var submitButton: some View {
        Button() {
            onboardingModel.authenticatedInCircle()
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
    CreateCircleView(onboardingModel: OnboardingModel())
}
