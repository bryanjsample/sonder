//
//  CreateEventViewModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

@Observable
final class CreateEventViewModel {
    
    var title: String = ""
    var description: String = ""
    var startTime: Date = Date.now
    var endTime: Date = Date.now.adding(hours: 1) ?? Date.now
    
    init() { }
    
}
