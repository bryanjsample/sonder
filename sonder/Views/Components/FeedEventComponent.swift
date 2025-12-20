//
//  FeedEventComponent.swift
//  sonder
//
//  Created by Bryan Sample on 12/20/25.
//

import SwiftUI
import SonderDTOs

struct FeedEventComponent: View {
    
    @Bindable var authModel: AuthModel
    @State var event: CalendarEventDTO
    
    var body: some View {
        eventComponent
            .background(.tertiary, in: RoundedRectangle(cornerRadius: Constants.padding))
            .padding(.horizontal, Constants.padding)
    }
    
}

extension FeedEventComponent {
    var eventComponent: some View {
        VStack {
            hostBlock
            eventBlock
                .textSelection(.enabled)
        }.padding(Constants.padding)
    }
    
    var hostBlock: some View {
        HStack {
            profilePicture
            VStack {
                name
                username
            }
            Spacer()
            eventDateStamp
        }.padding(.bottom, Constants.padding / 2)
    }
    
    var profilePicture: some View {
        AsyncImage(url: URL(string: self.event.host?.pictureUrl ?? "")) { result in
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
            Text("\(self.event.host?.firstName ?? "no first name") \(self.event.host?.lastName ?? "no last name")")
                .font(.title3)
            Spacer()
        }
    }
    
    var username: some View {
        HStack {
            Text(self.event.host?.username ?? "no username")
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
    
    var eventBlock: some View {
        VStack {
            eventTitle.padding(.bottom, Constants.padding / 2)
            eventTime
            eventDescription.padding(.vertical, Constants.padding / 2)
            eventTimeStamp
        }
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
    
    var eventTimeStamp: some View {
        HStack {
            Text(self.event.createdAt?.formatted(date: .omitted, time: .shortened) ?? "no time")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    var eventDateStamp: some View {
        HStack {
            Spacer()
            Text(self.event.createdAt?.formatted(date: .abbreviated, time: .omitted) ?? "no date")
                .font(.caption)
                .fontDesign(.monospaced)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
    let event = CalendarEventDTO(hostID: UUID(uuidString: "E6D09AE3-2BFF-4DBA-83C0-FFF98BA22D80") ?? UUID(), host: user, circleID: UUID(uuidString: "40312D89-632E-40D7-A468-07356390C642") ?? UUID(), title: "Test Event", description: "This is a test event going down to fundraise for our upcoming initiative. Come help out!", startTime: Date.now.adding(hours: 1) ?? Date.now, endTime: Date.now.adding(hours: 2) ?? Date.now, createdAt: Date.now)
    FeedEventComponent(authModel: AuthModel(), event: event)
}
