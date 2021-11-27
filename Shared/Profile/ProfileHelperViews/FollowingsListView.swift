//
//  FollowingsListView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/19/21.
//

import SwiftUI
import Kingfisher

struct FollowingsListView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var profileState: ProfileState
    var followings: [ListPersonModel]
    var pendingRequests: [ListPersonModel]
    var username: String
    
    var body: some View {
        
        if profileState != .userSelf && followings.count == 0 {
            VStack {
                Spacer()
                Text("💩 \(username) Is Not Following Anyone 💩")
                Spacer()
            }
        } else if profileState == .userSelf && pendingRequests.count == 0 && followings.count == 0 {
            VStack {
                Spacer()
                Text("💩 You Are Not Following Anyone 💩")
                Spacer()
            }
        } else {
        
            List {
                
                if profileState == .userSelf && pendingRequests.count > 0 {
                    Section("Pending Requests") {
                        ForEach(pendingRequests) { user in
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
                                Button(role: .destructive) {
                                    viewModel.cancelFollowerRequestFromSelf(otherUserId: user.userId)
                                } label: {
                                    Label("Cancel", systemImage: "trash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
                
                if followings.count > 0 {
                    Section("Following") {
                        ForEach(followings) { user in
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

//struct FollowingsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingsListView()
//    }
//}
