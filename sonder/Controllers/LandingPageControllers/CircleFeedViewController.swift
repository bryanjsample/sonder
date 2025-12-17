//
//  CircleFeedViewController.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

final class CircleFeedViewController {
    
    @Bindable var authModel: AuthModel
    let apiClient = DefaultAPIClient()
    let tokenController = TokenController()
    
    init(authModel: AuthModel) { self.authModel = authModel }
    
    
}
