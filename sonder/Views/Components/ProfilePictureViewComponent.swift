//
//  ProfilePictureViewComponent.swift
//  sonder
//
//  Created by Bryan Sample on 12/20/25.
//

import SwiftUI
import SonderDTOs

struct ProfilePictureViewComponent: View {
    
    let pictureURL: String
    let width: CGFloat
    let height: CGFloat
    
    init(pictureURL: String, width: CGFloat = 100, height: CGFloat = 100) {
        self.pictureURL = pictureURL
        self.width = width
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: URL(string: pictureURL)) { result in
            if let image = result.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height, alignment: .center)
                    .clipShape(.circle)
            } else {
                placeholderPicture
            }
        }
    }
}

extension ProfilePictureViewComponent {
    var placeholderPicture: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height, alignment: .topLeading)
    }
}
