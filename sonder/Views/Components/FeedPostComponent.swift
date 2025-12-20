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
    var feedPostComponentVM: FeedPostComponentViewModel? = nil
    @State var post: PostDTO
    
    init(authModel: AuthModel, post: PostDTO, author: UserDTO? = nil) {
        self.authModel = authModel
        self.feedPostComponentVM = FeedPostComponentViewModel(authModel: authModel)
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
        }.padding(.bottom, Constants.padding)
    }
    
    var profilePicture: some View {
        AsyncImage(url: URL(string: post.author?.pictureUrl ?? "")) { result in
            if let image = result.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40, alignment: .topLeading)
                    .clipShape(.circle)
            } else {
                placeholderPicture
            }
        }.padding(.trailing, Constants.padding)
    }
    
    var name: some View {
        HStack {
            Text(self.feedPostComponentVM?.getAuthorName(post.author) ?? "No name")
                .font(.title3)
            Spacer()
        }
    }
    
    var username: some View {
        HStack {
            Text(self.feedPostComponentVM?.getAuthorUsername(post.author) ?? "no username")
                .font(.caption)
                .fontDesign(.rounded)
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
            Text(post.content)
            Spacer()
        }.padding(.bottom, Constants.padding)
    }
    
    var postDateStamp: some View {
        HStack {
            Spacer()
            Text(post.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "no date")
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
        }
    }
    
    var postTimeStamp: some View {
        HStack {
            Text(post.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
