//
//  CreatePostView.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import SwiftUI

struct CreatePostView: View {
    
    @State var createPostVM = CreatePostViewModel()
    
    var body: some View {
        ZStack {
            BackgroundColor()
                .ignoresSafeArea(.all)
            VStack {
                Spacer()
                postForm
                submitButton
            }.ignoresSafeArea(.keyboard)
        }
    }
}

extension CreatePostView {
    
    var postForm: some View {
        Form {
            Section("Post Details") {
                TextField("Post Contents", text: $createPostVM.content)
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
    }
    
    var submitButton: some View {
        GenericButton(title: "Create Post") {
            print("create event")
        }
    }
    
}
