//
//  ProfilePicturePicker.swift
//  sonder
//
//  Created by Bryan Sample on 12/9/25.
//

import SwiftUI
import PhotosUI
import SonderDTOs

enum ProfilePictureType {
    case user, circle
}

struct ProfilePicturePicker: View {
    @State private var profilePictureItem: PhotosPickerItem?
    @State private var profilePicture: UIImage?
    
    var profilePictureType: ProfilePictureType
    @Bindable var authModel: AuthModel
    var defaultSystemImage: String
    var existingImageURL: URL? = nil
    
    init(_ profilePictureType: ProfilePictureType, authModel: AuthModel, defaultSystemImage: String) {
        self.profilePictureType = profilePictureType
        self.authModel = authModel
        self.defaultSystemImage = defaultSystemImage
        switch self.profilePictureType {
        case .user:
            self.existingImageURL = URL(string: self.authModel.user?.pictureUrl ?? "")
        case .circle:
            self.existingImageURL = URL(string: self.authModel.circle?.pictureUrl ?? "")
        }
    }
    
    var body: some View {
        
        PhotosPicker(selection: $profilePictureItem, matching: .images) {
            if profilePicture != nil {
                chosenProfilePicture
            } else if existingImageURL != nil {
                preexistingProfilePicture
            } else {
                placeholderPicture
            }
        }
        .onChange(of: profilePictureItem) {
            Task {
                if let loaded = try? await profilePictureItem?.loadTransferable(type: Data.self) {
                    profilePicture = UIImage(data: loaded)
                } else {
                    print("failed")
                }
            }
        }
        .padding(Constants.padding)
    }
}

extension ProfilePicturePicker {
    var placeholderPicture: some View {
        Image(systemName: defaultSystemImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100, alignment: .center)
    }
    
    var chosenProfilePicture: some View {
        Image(uiImage: profilePicture!)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(.circle)
    }
    
    var preexistingProfilePicture: some View {
        AsyncImage(url: URL(string: authModel.user?.pictureUrl ?? "")) { result in
            if let image = result.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(.circle)
            } else {
                placeholderPicture
            }
        }
    }
}

