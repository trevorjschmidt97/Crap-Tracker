//
//  FollowersListView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/19/21.
//

import SwiftUI
import Kingfisher

struct FollowersListView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var profileState: ProfileState
    var followers: [ListPersonModel]
    var pendingFollowers: [ListPersonModel]
    var username: String
    
    var body: some View {
        if (profileState != .userSelf && followers.count == 0) {
            VStack {
                Spacer()
                Text("💩 \(username) Has No Followers 💩")
                Spacer()
            }
        } else if profileState == .userSelf && pendingFollowers.count == 0 && followers.count == 0 {
            VStack {
                Spacer()
                Text("💩 You Have No Followers 💩")
                Spacer()
            }
        } else {
            List {
                
                if profileState == .userSelf && pendingFollowers.count > 0 {
                    Section("Pending Followers") {
                        ForEach(pendingFollowers) { user in
                            
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
                                    }
                                    .padding(.leading)
                                }
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    viewModel.acceptPendingFollower(otherUserId: user.userId)
                                } label: {
                                    Label("Accept", systemImage: "checkmark")
                                }
                                .tint(.green)

                                Button(role: .destructive) {
                                    viewModel.rejectPendingFollower(otherUserId: user.userId)
                                } label: {
                                    Label("Reject", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                
                if followers.count > 0 {
                    Section("Followers") {
                        ForEach(followers) { user in
                            
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
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct FollowersListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowersListView()
//    }
//}
