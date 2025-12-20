//
//  CreateCircleView.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct CreateCircleView: View {
    
    @Bindable var authModel: AuthModel
    @State private var name: String = ""
    @State var description: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                SonderTitleText()
                ProfilePicturePicker(.circle, authModel: authModel, defaultSystemImage: "figure.socialdance.circle.fill")
                circleForm
                submitButton
            }
        }
    }
}

extension CreateCircleView {
    var circleForm: some View {
        Form {
            Section("Circle Information") {
                TextField("Circle Name", text: $name)
                    .font(.title2)
                GenericTextInput(inputDescription: "Circle Description...", textBinding: $description)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        GenericButton(title: "Create Circle") {
            let onboardingController = OnboardingController(authModel: authModel)
            onboardingController.onboardNewCircle(circleName: name, description: description)
        }
    }
}

#Preview {
    CreateCircleView(authModel: AuthModel())
}
