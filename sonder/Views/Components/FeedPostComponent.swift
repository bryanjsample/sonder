//
//  FeedPostComponent.swift
//  sonder
//
//  Created by Bryan Sample on 12/19/25.
//

import SwiftUI
import SonderDTOs

struct FeedPostComponent: View {
    
    @Bindable var authModel: AuthModel
    @State var post: PostDTO
    
    init(authModel: AuthModel, post: PostDTO, author: UserDTO? = nil) {
        self.authModel = authModel
        self.post = post
    }

    
    var body: some View {
        postComponent
            .background(.tertiary, in: RoundedRectangle(cornerRadius: Constants.padding))
            .padding(.horizontal, Constants.padding)
    }
    
}

extension FeedPostComponent {
    
    var postComponent: some View {
        VStack {
            authorBlock
            postBlock
        }.padding(Constants.padding)
    }
    
    var authorBlock: some View {
        HStack {
            profilePicture
            VStack {
                name
                username
            }
            Spacer()
            postDateStamp
        }.padding(.bottom, Constants.padding / 2)
    }
    
    var profilePicture: some View {
        AsyncImage(url: URL(string: self.post.author?.pictureUrl ?? "")) { result in
            if let image = result.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipShape(.circle)
            } else {
                placeholderPicture
            }
        }.padding(.trailing, Constants.padding / 2)
    }
    
    var name: some View {
        HStack {
            Text("\(self.post.author?.firstName ?? "no first name") \(self.post.author?.lastName ?? "no last name")")
                .font(.title3)
            Spacer()
        }
    }
    
    var username: some View {
        HStack {
            Text(self.post.author?.username ?? "no username")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    var placeholderPicture: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30, alignment: .topLeading)
    }
    
    var postBlock: some View {
        VStack {
            postContent
            postTimeStamp
        }
    }
    
    var postContent: some View {
        HStack {
            Text(self.post.content)
            Spacer()
        }.padding(.bottom, Constants.padding / 2)
    }
    
    var postDateStamp: some View {
        HStack {
            Spacer()
            Text(self.post.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "no date")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
        }
    }
    
    var postTimeStamp: some View {
        HStack {
            Text(self.post.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
    let post = PostDTO(circleID: UUID(uuidString: "40312D89-632E-40D7-A468-07356390C642") ?? UUID(), authorID: UUID(uuidString: "E6D09AE3-2BFF-4DBA-83C0-FFF98BA22D80") ?? UUID(), author: user , content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", createdAt: Date.now)
    FeedPostComponent(authModel: AuthModel(), post: post)
}
