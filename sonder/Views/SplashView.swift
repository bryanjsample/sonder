//
//  SplashView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            SonderTitleText()
            Spacer()
            ProgressView()
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    SplashView()
}
