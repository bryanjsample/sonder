//
//  UserOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct UserOnboardingView: View {
    
    @Bindable var onboardingModel: OnboardingModel
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var username: String = ""
    
    var body: some View {
        ZStack {
            
            BackgroundColor()
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                SonderTitleText.titleBlock
                ProfilePicturePicker(defaultSystemImage: "person.circle.fill")
                onboardingForm
                submitButton
            }
        }
    }
}

extension UserOnboardingView {
    var onboardingForm: some View {
        Form {
            Section("User Information") {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
        }
        .scrollDisabled(true)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        Button() {
            onboardingModel.authenticatedNotInCircle()
        } label: {
            Text("Create User")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
}

#Preview {
    UserOnboardingView(onboardingModel: OnboardingModel())
}
