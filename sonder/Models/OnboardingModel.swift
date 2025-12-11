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

    init() { }
    
    func notOnboarded() {
        status = .notOnboarded
    }
    
    func authenticatedNotInCircle() {
        status = .authenticatedNotInCircle
    }
    
    func authenticatedInCircle() {
        status = .authenticatedInCircle
    }
    
    func unauthenticated() {
        status = .unauthenticated
    }
    
    func loading() {
        status = .loading
    }
}

