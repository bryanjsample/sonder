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
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                SonderTitleText.titleBlock
                ProfilePicturePicker(defaultSystemImage: "figure.socialdance.circle.fill")
                circleForm
                submitButton
            }.ignoresSafeArea(.keyboard)
        }
    }
}

extension CreateCircleView {
    var circleForm: some View {
        Form {
            Section("Circle Information") {
                TextField("Circle Name", text: $name)
                    .font(.title2)
                descriptionInput
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var descriptionInput: some View {
        ZStack(alignment: .topLeading) {
            if !isFocused && description.isEmpty {
                Text("Circle Description...")
                    .allowsHitTesting(false)
                    .opacity(0.30)
                    .font(.body)
            }
            
            TextEditor(text: $description)
                .focused($isFocused)
                .font(.body)
        }
    }
    
    var submitButton: some View {
        Button() {
            handlePress()
        } label: {
            Text("Create Circle")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.borderedProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
        .ignoresSafeArea(.keyboard)
    }
    
    func handlePress() {
        let onboardingController = OnboardingController()
        onboardingController.onboardNewCircle(with: onboardingModel, circleName: name, description: description)
    }
}

#Preview {
    CreateCircleView(onboardingModel: OnboardingModel())
}
