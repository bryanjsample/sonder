//
//  CirclesView.swift
//  sonder
//
//  Created by Bryan Sample on 12/5/25.
//


import SwiftUI
import SonderDTOs

struct CirclesView: View {
    
    @Bindable var authModel: AuthModel
    @State private var circle = CircleModel()
    var circlesVM: CirclesViewModel? = nil
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.circlesVM = CirclesViewModel(authModel: authModel)
    }

    var body: some View {
        VStack {
            circleInfo
                .frame(maxWidth: .infinity)
                .background(.tertiary)
            membersBlock
            Spacer()
            inviteCodeBlock
        }
    }
}

extension CirclesView {
    
    var circleInfo: some View {
        VStack {
            titleBar
            circlePicture
            circleDescription
                .padding(.bottom, Constants.padding)
        }
    }
    
    var titleBar: some View {
        circleName
            .padding(Constants.padding)
    }
    
    var circleName: some View {
        Text(authModel.circle?.name ?? "no circle name")
            .font(.title)
    }
    
    var circlePicture: some View {
        AsyncImage(url: URL(string: self.authModel.circle?.pictureUrl ?? "")) { result in
            if let image = result.image {
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(.circle)
            } else {
                placeholderPicture
            }
        }.padding(Constants.padding)
    }
    
    var placeholderPicture: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100, alignment: .topLeading)
    }
    
    var circleDescription: some View {
        Text(authModel.circle?.description ?? "no circle description")
            .font(.subheadline)
    }
    
    var circleMembersHeader: some View {
        HStack {
            Text("Members")
                .font(.title2)
                .padding([.top, .leading, .horizontal], Constants.padding)
            Spacer()
        }
    }
    
    var circleMembers: some View {
        ScrollView {
            LazyVStack {
                ForEach(authModel.circle?.members ?? []) { member in
                    UserInfoTile(member)
                }
            }
        }
    }
    
    var membersBlock: some View {
        VStack {
            circleMembersHeader
            circleMembers
        }
    }
    
    var inviteCodeBlock: some View {
        VStack {
            Text(circle.circleInvitation?.invitation ?? "Invitation not generated")
                .font(.headline)
                .fontDesign(.monospaced)
                .padding(.top, Constants.padding * 2)
                .textSelection(.enabled)
            generateInviteCodeButton.onAppear {
                Task {
                    if circle.circleInvitation == nil {
                        try await circlesVM?.getCircleInvitation(on: circle)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.tertiary)
    }
    
    var generateInviteCodeButton: some View {
        GenericButton(title: "Generate Invite Code") {
            Task {
                try await circlesVM?.generateCircleInviteCode(on: circle)
            }
        }
    }
}

#Preview {
    let authModel = AuthModel()
    let circle = CircleDTO(name: "Pied Piper Pickled Peppers", description: "We compress data and compress peppers into pickles.",
        pictureUrl: "https://media.istockphoto.com/id/1480574526/photo/happy-multigenerational-people-having-fun-sitting-on-grass-in-a-public-park.jpg?s=612x612&w=0&k=20&c=iIzSiY2FK9mWTCmV8Ip8zpvXma7f1Qbd-UuKXNJodPg="
    )
    let user = UserDTO(email: "bryanjsample@gmail.com", firstName: "Bryan", lastName: "Sample", username: "bsizzle", pictureUrl: "https://images.pexels.com/photos/3777931/pexels-photo-3777931.jpeg")
    let members = [
        user,
        UserDTO(id: UUID(), email: "richieflo22@gmail.com", firstName: "Richard", lastName: "Flores", username: "hockeylover337", pictureUrl: "https://media.istockphoto.com/id/1388253782/photo/positive-successful-millennial-business-professional-man-head-shot-portrait.jpg?s=612x612&w=0&k=20&c=uS4knmZ88zNA_OjNaE_JCRuq9qn3ycgtHKDKdJSnGdY="),
        UserDTO(id: UUID(), email: "cobainsama@gmail.com", firstName: "Cobain", lastName: "Leftwich", username: "cobainsama", pictureUrl: "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D"),
        UserDTO(id: UUID(), email: "kelissamaree@gmail.com", firstName: "Kelissa", lastName: "Zamora", username: "beanbagbarbie", pictureUrl: "https://media.istockphoto.com/id/1437816897/photo/business-woman-manager-or-human-resources-portrait-for-career-success-company-we-are-hiring.jpg?s=612x612&w=0&k=20&c=tyLvtzutRh22j9GqSGI33Z4HpIwv9vL_MZw_xOE19NQ="),
    ]
    authModel.updateCircle(circle)
    authModel.updateUser(user)
    authModel.updateCircleMembers(members)
    return CirclesView(authModel: authModel)
}
