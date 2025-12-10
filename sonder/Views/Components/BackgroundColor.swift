//
//  BackgroundColor.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct BackgroundColor: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        colorScheme == .dark ? Color.black.opacity(0.8) : Color.gray.opacity(0.1)
    }
}

