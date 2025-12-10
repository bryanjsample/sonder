//
//  OnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @Bindable var authVM: AuthViewModel
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var username: String = ""
    
    var body: some View {
        Spacer()
        SonderTitleText.titleBlock
        ProfilePicturePicker(defaultSystemImage: "person.circle.fill")
        onboardingForm
        submitButton
    }
}

extension OnboardingView {
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
    }
    
    var submitButton: some View {
        Button() {
            print("Created User")
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
    OnboardingView(authVM: AuthViewModel())
}
