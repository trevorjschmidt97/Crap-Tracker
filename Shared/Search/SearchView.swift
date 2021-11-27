//
//  SearchView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var inputString = ""
    
    var filteredPeople: [UserSearchModel] {
        if inputString == "" { return viewModel.model.users }
        return viewModel.model.users.filter {
            ($0.username.lowercased() + $0.email.lowercased()).contains(inputString.lowercased())
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredPeople) { user in
                
                NavigationLink {
                    ProfileView(userId: user.userId)
                } label: {
                    HStack {
                        if let profilePicUrl = user.profilePicUrl {
                            KFImage(URL(string: profilePicUrl)!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(30)
                                .overlay(Circle().stroke(.secondary, lineWidth: 2))
                        } else {
                            ZStack {
                                Circle()
                                    .fill(.gray)
                                    .opacity(50)
                                    .overlay(Circle().stroke(.white, lineWidth: 2))
                                    .frame(width: 60, height: 60)
                                Text("\(String(user.username.first!))")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(user.username)")
                            if let userId = FirebaseAuthService.shared.getUserId(), userId == user.userId {
                                Text("you")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.followingsIdSet.contains(user.userId) {
                                Text("following")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.followersIdSet.contains(user.userId) {
                                Text("follows you")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.pendingRequestsIdSet.contains(user.userId) {
                                Text("requested")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.leading)
                    }
                }
            }
        }
            .searchable(text: $inputString)
            .navigationTitle("Search")
            .onAppear {
                viewModel.onAppear()
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
