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
                SonderTitleText()
                ProfilePicturePicker(
                    .user,
                    authModel: authModel,
                    defaultSystemImage: "person.circle.fill"
                )
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
        GenericButton(title: "Create User") {
            let onboardingController = OnboardingController(authModel: authModel)
            onboardingController.onboardNewUser(firstName: firstName, lastName: lastName, email: email, username: username)
        }
    }
}

#Preview {
    UserOnboardingView(authModel: AuthModel())
}
