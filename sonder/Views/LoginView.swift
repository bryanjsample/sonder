//
//  LoginView.swift
//  sonder
//
//  Created by Bryan Sample on 12/2/25.
//

import SwiftUI

struct LoginView: View {
    @Bindable var authVM: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
            SonderTitleText.titleBlock
            Spacer()
            GoogleLoginButton(authVM: authVM)
            Spacer()
            Spacer()
        }
        .padding(Constants.padding)
    }
}

#Preview {
    LoginView(authVM: AuthViewModel())
}
