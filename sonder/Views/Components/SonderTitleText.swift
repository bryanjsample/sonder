//
//  SonderTitleText.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI

struct SonderTitleText {
    static var titleBlock: some View {
        VStack {
            SonderTitleText.title
            SonderTitleText.subText
            SonderTitleText.emojiRow
        }
    }
    
    static var title: some View {
        Text("sonder")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    static var subText: some View {
        Text("get connected with your circle")
            .font(.caption)
            .multilineTextAlignment(.center)
    }
    
    static var emojiRow: some View {
        HStack{
            Spacer()
            Text("🗓️")
            Spacer()
            Text("🏋")
            Spacer()
            Text("📝")
            Spacer()
        }.padding(.vertical, Constants.padding)
    }
}
