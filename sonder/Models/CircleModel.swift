//
//  CircleModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI
import SonderDTOs

@Observable
final class CircleModel {
    
    var circleInvitation: CircleInvitationDTO? = nil
    
    init() { }
    
    func updateInvitation(_ circleInvitation: CircleInvitationDTO) {
        self.circleInvitation = circleInvitation
    }
    
    
}
