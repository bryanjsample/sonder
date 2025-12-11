//
//  LoginView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct LoginView: View {
    @Bindable var onboardingModel: OnboardingModel
    
    var body: some View {
        VStack {
            Spacer()
            SonderTitleText.titleBlock
            Spacer()
            GoogleLoginButton(onboardingModel: onboardingModel)
            Spacer()
            Spacer()
        }
        .padding(Constants.padding)
    }
}

#Preview {
    LoginView(onboardingModel: OnboardingModel())
}
