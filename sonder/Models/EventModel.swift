//
//  EventModel.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI
import SonderDTOs

final class EventModel {
    
    @State var title: String = ""
    @State var description: String = ""
    @State var startTime: Date = Date.now
    @State var endTime: Date = Date.now.adding(hours: 1) ?? Date.now
    
    init() { }
    
}
