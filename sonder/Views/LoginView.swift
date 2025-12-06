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
            title
            subText
            emojiRow
            Spacer()
            GoogleLoginButton(authVM: authVM)
            Spacer()
            Spacer()
        }
        .padding(Constants.padding)
    }
}

extension LoginView {
    
    var title: some View {
        Text("sonder")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    var subText: some View {
        Text("get connected with your circle")
            .font(.caption)
            .multilineTextAlignment(.center)
    }
    
    var emojiRow: some View {
        HStack{
            Spacer()
            Text("🗓️")
            Spacer()
            Text("🏋")
            Spacer()
            Text("📝")
            Spacer()
        }.padding(.vertical, Constants.padding)
    }
}

//#Preview {
//    LoginView()
//}
