//
//  UserOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import SonderDTOs

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
            }.ignoresSafeArea(.keyboard)
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
                    .keyboardType(.emailAddress)
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
        }.onAppear {
            firstName = onboardingModel.user?.firstName ?? ""
            lastName = onboardingModel.user?.lastName ?? ""
            email = onboardingModel.user?.email ?? ""
            username = onboardingModel.user?.username ?? ""
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        Button() {
            Task {
                try await handlePress()
            }
        } label: {
            Text("Create User")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.glassProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
    
    func handlePress() async throws {
        let onboardingController = OnboardingController()
        try await onboardingController.onboardNewUser(with: onboardingModel, firstName: firstName, lastName: lastName, email: email, username: username)
    }
}

#Preview {
    UserOnboardingView(onboardingModel: OnboardingModel())
}
