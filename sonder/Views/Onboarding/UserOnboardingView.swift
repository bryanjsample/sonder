//
//  UserOnboardingView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI
import SonderDTOs

struct UserOnboardingView: View {
    
    @Bindable var authModel: AuthModel
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
            firstName = authModel.user?.firstName ?? ""
            lastName = authModel.user?.lastName ?? ""
            email = authModel.user?.email ?? ""
            username = authModel.user?.username ?? ""
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        Button() {
            Task {
                await handlePress()
            }
        } label: {
            Text("Create User")
                .frame(maxWidth: .infinity)
                .padding(Constants.padding)
        }
        .buttonStyle(.borderedProminent)
        .padding(Constants.padding)
        .fontWeight(.bold)
    }
    
    func handlePress() async {
        let onboardingController = OnboardingController()
        onboardingController.onboardNewUser(with: authModel, firstName: firstName, lastName: lastName, email: email, username: username)
    }
}

#Preview {
    UserOnboardingView(authModel: AuthModel())
}
