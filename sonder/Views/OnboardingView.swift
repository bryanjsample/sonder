//
//  OnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var username: String = ""
    @State var circleInviteCode: String = ""
    // picture
    
    var body: some View {
        Spacer()
        SonderTitleText.titleBlock
        ProfilePicturePicker()
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
            
            Section("Circle Information") {
                TextField("Circle Invitation Code", text: $circleInviteCode)
            }
        }
    }
    
    var submitButton: some View {
        Button() {
            print("Joined circle")
        } label: {
            buttonText
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
    }
    
    var buttonText: some View {
        Text(circleInviteCode.isEmpty ? "Create Circle" : "Join Circle")
            .frame(maxWidth: .infinity) //  minHeight: 35.0
            .padding(Constants.padding)
        
    }
}

#Preview {
    OnboardingView()
}
