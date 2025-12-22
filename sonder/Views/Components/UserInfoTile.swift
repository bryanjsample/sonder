//
//  UserInfoTile.swift
//  sonder
//
//  Created by Bryan Sample on 12/20/25.
//

import SwiftUI
import SonderDTOs

struct UserInfoTile: View {
    
    @State var user: UserDTO
    
    init(_ user: UserDTO) { self.user = user }
    
    var body: some View {
        HStack {
            profilePicture
            userInfo
            Spacer()
        }
        .padding(Constants.padding)
        .background(.tertiary, in: .capsule)
    }
}

extension UserInfoTile {
    
    var profilePicture: some View {
        ProfilePictureFrame(pictureURL: self.user.pictureUrl ?? "", width: 40, height: 40)
            .padding(.trailing, Constants.padding / 2)
    }
    
    var userInfo: some View {
        VStack {
            name
            username
        }
    }
    
    var name: some View {
        HStack {
            Text("\(self.user.firstName) \(self.user.lastName)")
                .font(.headline)
            Spacer()
        }
    }
    
    var username: some View {
        HStack {
            Text(self.user.username ?? "no username")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
        let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
    UserInfoTile(user)
}
