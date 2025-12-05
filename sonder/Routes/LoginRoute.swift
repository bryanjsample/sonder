//
//  LoginRoute.swift
//  sonder
//
//  Created by Bryan Sample on 12/3/25.
//

import SonderDTOs

enum LoginRoute {
    case circleInvitation
    case circleHome(UserDTO)
    case onboarding(UserDTO)
    case error(String)
}
