//
//  ProfilePicturePicker.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI
import PhotosUI

struct ProfilePicturePicker: View {
    @State private var profilePictureItem: PhotosPickerItem?
    @State private var profilePicture: Image?
    var defaultSystemImage: String
    
    var body: some View {
            PhotosPicker(selection: $profilePictureItem, matching: .images) {
            if let profilePicture {
                profilePicture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(.circle)
            } else {
                Image(systemName: defaultSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
            }
        }
        .onChange(of: profilePictureItem) {
            Task {
                if let loaded = try? await profilePictureItem?.loadTransferable(type: Image.self) {
                    profilePicture = loaded
                } else {
                    print("failed")
                }
            }
        }
        .padding(Constants.padding)
    }
}

