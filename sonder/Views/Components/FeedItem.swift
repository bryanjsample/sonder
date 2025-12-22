//
//  FeedItem.swift
//  sonder
//
//  Created by Bryan Sample on 12/20/25.
//

import SwiftUI
import SonderDTOs

struct FeedItem: View {
    
    @Bindable var authModel: AuthModel
    @State var item: FeedItemDTO
    var newPostContent: Binding<String>?
    
    init(authModel: AuthModel, item: FeedItemDTO) {
        self.authModel = authModel
        self.item = item
        self.newPostContent = nil
    }
    
    init(authModel: AuthModel, newPostContent: Binding<String>) {
        self.authModel = authModel
        let user = authModel.user ?? UserDTO(email: "test@gmail.com", firstName: "Ftest", lastName: "Ltest")
        let post = PostDTO(id: UUID(), circleID: UUID(), authorID: user.id ?? UUID(), author: user, content: "this shouldnt be showing in view", createdAt: Date.now)
        self.item = FeedItemDTO(from: post)
        self.newPostContent = newPostContent
    }
    
    var body: some View {
        VStack {
            ownerBlock
            switch item {
            case .post(let post):
                FeedPostDetailsComponent(post, newPostContent: self.newPostContent)
                    .textSelection(.enabled)
            case .event(let event):
                FeedEventDetailsComponent(event)
                    .textSelection(.enabled)
            }
        }
        .padding(Constants.padding)
        .background(.tertiary, in: RoundedRectangle(cornerRadius: Constants.padding))
        .padding(.horizontal, Constants.padding)
    }
}

extension FeedItem {
    
    var ownerBlock: some View {
        HStack {
            ProfilePictureFrame(pictureURL: item.ownerPictureUrl ?? "", width: 40, height: 40)
                .padding(.trailing, Constants.padding / 2)
            VStack {
                name
                username
            }
            Spacer()
            datestamp
        }.padding(.bottom, Constants.padding / 2)
    }
    
    var timestamp: some View {
        HStack {
            Text(self.item.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    var datestamp: some View {
        HStack {
            Spacer()
            Text(self.item.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "no date")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
        }
    }
    
    var name: some View {
        HStack {
            Text(self.item.fullName)
                .font(.title3)
            Spacer()
        }
    }
    
    var username: some View {
        HStack {
            Text(self.item.username ?? "no username")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

private struct FeedPostDetailsComponent: View {
    
    @State var post: PostDTO
    var newPostContent: Binding<String>?
    
    init(_ post: PostDTO) {
        self.post = post
    }
    
    init(_ post: PostDTO, newPostContent: Binding<String>?) {
        self.post = post
        if let content = newPostContent {
            self.newPostContent = content
        } else {
            self.newPostContent = nil
        }
    }
    
    var body: some View {
        postContent
        timestamp
    }
    
    var postContent: some View {
        HStack {
            if let content = self.newPostContent {
                GenericTextEditor(inputDescription: "Post Content...", textBinding: content)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.padding))
                    .scrollDismissesKeyboard(.immediately)
            } else {
                Text(self.post.content)
            }
            Spacer()
        }.padding(.bottom, Constants.padding / 2)
    }

    var timestamp: some View {
        HStack {
            Text(self.post.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

private struct FeedEventDetailsComponent: View {
    
    @State var event: CalendarEventDTO
    
    init(_ event: CalendarEventDTO) { self.event = event }
    
    var body: some View {
        eventTitle.padding(.bottom, Constants.padding / 2)
        eventTime
        eventDescription.padding(.vertical, Constants.padding / 2)
        timestamp
    }
    
    var eventTitle: some View {
        HStack {
            Text("\(event.title)")
                .font(.title)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    var eventTime: some View {
        VStack {
            HStack {
                Text("Starts: \(event.startTime.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .fontDesign(.monospaced)
                Spacer()
            }
            HStack {
                Text("Ends: \(event.endTime.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .fontDesign(.monospaced)
                Spacer()
            }
        }
    }
    
    var eventDescription: some View {
        HStack {
            Text("\(event.description)")
            Spacer()
        }
    }
    
    var timestamp: some View {
        HStack {
            Text(self.event.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    LandingPageView(authModel: AuthModel())
}

//#Preview {
//    let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
//    let event = CalendarEventDTO(hostID: UUID(uuidString: "E6D09AE3-2BFF-4DBA-83C0-FFF98BA22D80") ?? UUID(), host: user, circleID: UUID(uuidString: "40312D89-632E-40D7-A468-07356390C642") ?? UUID(), title: "Test Event", description: "This is a test event going down to fundraise for our upcoming initiative. Come help out!", startTime: Date.now.adding(hours: 1) ?? Date.now, endTime: Date.now.adding(hours: 2) ?? Date.now, createdAt: Date.now)
//    FeedEventComponent(authModel: AuthModel(), event: event)
//}

//#Preview {
//    let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
//    let post = PostDTO(circleID: UUID(uuidString: "40312D89-632E-40D7-A468-07356390C642") ?? UUID(), authorID: UUID(uuidString: "E6D09AE3-2BFF-4DBA-83C0-FFF98BA22D80") ?? UUID(), author: user , content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", createdAt: Date.now)
//    FeedPostComponent(authModel: AuthModel(), post: post)
//}
