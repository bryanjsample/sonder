//
//  LoginView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct LoginView: View {
    @Bindable var authModel: AuthModel
    
    var body: some View {
        VStack {
            Spacer()
            SonderTitleText()
            Spacer()
            GoogleLoginButton(authModel: authModel)
            Spacer()
            Spacer()
        }
        .padding(Constants.padding)
    }
}

#Preview {
    LoginView(authModel: AuthModel())
}
