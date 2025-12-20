//
//  AuthModel.swift
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
final class AuthModel {

    var status: AuthStatus = .unauthenticated
    var user: UserDTO? = nil
    var circle: CircleDTO? = nil

    init() { }
    
    func notOnboarded() {
        self.status = .notOnboarded
    }
    
    func authenticatedNotInCircle() {
        self.status = .authenticatedNotInCircle
    }
    
    func authenticatedInCircle() {
        self.status = .authenticatedInCircle
    }
    
    func unauthenticated() {
        self.status = .unauthenticated
        self.user = nil
        self.circle = nil
    }
    
    func loading() {
        self.status = .loading
    }
    
    func updateUser(_ user: UserDTO) {
        self.user = user
    }
    
    func updateCircle(_ circle: CircleDTO) {
        self.circle = circle
        self.user?.circleID = circle.id
    }
    
    func updateCircleMembers(_ members: [UserDTO]) {
        self.circle?.members = members
        print("in authModel: members = \(members)")
        print("in authModel: modelMembers = \(self.circle?.members?.debugDescription ?? "no array")")
    }
}

