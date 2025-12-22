//
//  CreatePostView.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var authModel: AuthModel
    @State var createPostVM: CreateFeedItemViewModel
    @State var postContent: String = ""
    
    init(authModel: AuthModel) {
        self.authModel = authModel
        self.createPostVM = CreateFeedItemViewModel(authModel: authModel) // this is not the same object as self.authModel after init finishes ??? test this
    }
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                // New Post in X
                Spacer()
                FeedItem(authModel: authModel, newPostContent: $postContent)
                Spacer()
                submitButton
            }
        }
    }
}

extension CreatePostView {
    
    var submitButton: some View {
        GenericButton(title: "Create Post") {
            print("on submit: post content = \(postContent)")
            createPostVM.createNewPost(postContent)
            dismiss()
        }
    }
    
}

#Preview {
    LandingPageView(authModel: AuthModel(), tabSelection: .post)
}


//               Form {
//                    Section("Post Details") {
//                        GenericTextInput(inputDescription: "Post Content...", textBinding: $postContent)
//                    }
//                }
//                .scrollDismissesKeyboard(.immediately)
//                .scrollContentBackground(.hidden)
