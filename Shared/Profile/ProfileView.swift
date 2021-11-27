//
//  ProfileView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import SwiftUI
import PhotosUI

enum ContentState {
    case craps, followers, followings
}

struct ProfileView: View {
    var userId: String
    
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State private var contentState: ContentState = .craps
    @State private var settingsButtonPressed = false
    @State private var followingButtonPressed = false
    @State private var requestedButtonPressed = false
    @State private var changePrivacyAlertShown = false
    @State private var changeProfilePicShown = false
    
    @State private var inputImage: UIImage?
    
    private var profileState: ProfileState {
        guard let userSelfId = FirebaseAuthService.shared.getUserId() else { return .userSelf }
        
        if userId == userSelfId {
            return .userSelf
        } else if AppViewModel.shared.model.followingsIdSet.contains(userId) {
            return .following
        } else if AppViewModel.shared.model.pendingRequestsIdSet.contains(userId) {
            return .requested
        } else if AppViewModel.shared.model.followersIdSet.contains(userId) {
            return .follower
        } else {
            return .random
        }
    }
    
    var body: some View {
        VStack {
            // Top Part
            HStack {
                // Image
                ProfileImageView(username: viewModel.model.username, profilePicUrl: viewModel.model.profilePicUrl)
                    .padding()
                // Stats/Button
                VStack {
                    // Stats
                    HStack {
                        StatsButtonView(count: viewModel.model.poops.count, contentState: $contentState, selfState: .craps)
                        Spacer()
                        StatsButtonView(count: viewModel.model.followers.count, contentState: $contentState, selfState: .followers)
                        Spacer()
                        StatsButtonView(count: viewModel.model.followings.count, contentState: $contentState, selfState: .followings)
                    }
                    // Button
                    FollowButtonView(viewModel: viewModel,
                                     profileState: profileState,
                                     settingsButtonPressed: $settingsButtonPressed,
                                     followingButtonPressed: $followingButtonPressed,
                                     requestedButtonPressed: $requestedButtonPressed)
                }
                .padding()
            }
            
            // content
            if let selfUserId = FirebaseAuthService.shared.getUserId(), selfUserId == userId || AppViewModel.shared.model.followingsIdSet.contains(userId) || !viewModel.model.isPrivate {
                    switch contentState {
                    case .craps:
                        if viewModel.model.poops.count == 0 {
                            if profileState == .userSelf {
                                VStack {
                                    Spacer()
                                    Text("💩 You Have No Pins 💩")
                                    Spacer()
                                }
                            } else {
                                VStack {
                                    Spacer()
                                    Text("💩 \(viewModel.model.username) Has No Pins 💩")
                                    Spacer()
                                }
                            }
                            
                        } else {
                            MapKitView(manager: locationManager, poops: viewModel.model.poops, fromProfile: true)
                        }
                    case .followers:
                        FollowersListView(viewModel: viewModel, profileState: profileState, followers: viewModel.model.followers, pendingFollowers: viewModel.model.followerRequests, username: viewModel.model.username)
                    case .followings:
                        FollowingsListView(viewModel: viewModel, profileState: profileState, followings: viewModel.model.followings, pendingRequests: viewModel.model.pendingRequests, username: viewModel.model.username)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("💩 \(viewModel.model.username) Is Private 💩")
                        Spacer()
                    }
                }
        }
            .navigationTitle("\(viewModel.model.username)")
            .onAppear {
                viewModel.onAppear(userId: userId)
            }
            .actionSheet(isPresented: $settingsButtonPressed) {
                ActionSheet(title: Text("Settings"), message: nil, buttons: [
                    .default(Text("Update Profile Picture")) { changeProfilePicShown.toggle() },
                    .default(Text("Change Privacy Settings")) { changePrivacyAlertShown.toggle() },
                    .default(Text("Log Out")) { AppViewModel.shared.signOut() },
                    .cancel()
                ])
            }
            .alert("Change Privacy?", isPresented: $changePrivacyAlertShown) {
                Button("Switch to \(viewModel.model.isPrivate ? "Public" : "Private")") { viewModel.changePrivacy() }
                Button("Stay \(viewModel.model.isPrivate ? "Private" : "Public")", role: .cancel) { changePrivacyAlertShown = false }
            }
            .alert("Careful", isPresented: $followingButtonPressed, actions: {
                Button("Unfollow") { viewModel.unfollow() }
                Button("Cancel", role: .cancel) { followingButtonPressed = false }
            }, message: {
                Text("Would you like to unfollow \(viewModel.model.username)?")
            })
            .alert("Careful", isPresented: $requestedButtonPressed, actions: {
                Button("Cancel Follow Request") { viewModel.cancelFollowRequest() }
                Button("Cancel", role: .cancel) { requestedButtonPressed = false }
            }, message: {
                Text("Would you like to cancel your request to follow \(viewModel.model.username)?")
            })
            .sheet(isPresented: $changeProfilePicShown) {
                if let inputImage = inputImage {
                    viewModel.updateProfilePicture(image: inputImage)
                }
            } content: {
                ImagePicker(image: $inputImage)
            }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
