//
//  sonderApp.swift
//  sonder
//
//  Created by Bryan Sample on 11/23/25.
//

import SwiftUI
import GoogleSignIn

@main
struct sonderApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                CircleFeedView()
            }
            
            
            
            
            LoginView()
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        print(user!)
                        print(error!)
                    }
                }
                .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
