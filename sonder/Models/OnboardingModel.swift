//
//  OnboardingModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SwiftUI
import SonderDTOs
import GoogleSignIn

enum AuthStatus: Equatable {
    case loading, notOnboarded, authenticatedNotInCircle, authenticatedInCircle, unauthenticated, error(String)
}

@Observable
final class OnboardingModel {

    var status: AuthStatus = .unauthenticated
    var user: UserDTO? = nil

    init() { }
    
    func notOnboarded(_ user: UserDTO) {
        self.status = .notOnboarded
        self.user = user
    }
    
    func authenticatedNotInCircle() {
        self.status = .authenticatedNotInCircle
    }
    
    func authenticatedInCircle() {
        self.status = .authenticatedInCircle
    }
    
    func unauthenticated() {
        self.status = .unauthenticated
    }
    
    func loading() {
        self.status = .loading
    }
}

