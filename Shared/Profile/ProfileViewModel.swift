//
//  ProfileViewModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation
import SwiftUI

enum ProfileState {
    case userSelf
    case following
    case requested
    case follower
    case random
}

class ProfileViewModel: ObservableObject {
    
    var userId: String = ""
    @Published var model = ProfileModel()
    
    func onAppear(userId: String) {
        self.userId = userId
        FirebaseDatabaseService.shared.pullProfileInfo(userId: userId) { [weak self] result in
            switch result {
            case .success(let profileModel):
                DispatchQueue.main.async {
                    self?.model = profileModel
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func follow() {
        guard let userSelfId = FirebaseAuthService.shared.getUserId() else { return }
        
        if model.isPrivate {
            FirebaseDatabaseService.shared.requestToFollow(userSelfId: userSelfId,
                                                           otherId: userId,
                                                           otherUsername: model.username,
                                                           otherProfilePicUrl: model.profilePicUrl)
        } else {
            FirebaseDatabaseService.shared.follow(userSelfId: userSelfId,
                                                  otherId: userId,
                                                  otherUsername: model.username,
                                                  otherProfilePicUrl: model.profilePicUrl)
        }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func unfollow() {
        guard let userSelfId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDatabaseService.shared.unfollow(selfId: userSelfId, otherId: userId)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func cancelFollowRequest() {
        guard let userSelfId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDatabaseService.shared.cancelFollowRequest(selfId: userSelfId, otherId: userId)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func cancelFollowerRequestFromSelf(otherUserId: String) {
        FirebaseDatabaseService.shared.cancelFollowRequest(selfId: userId, otherId: otherUserId)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func acceptPendingFollower(otherUserId: String) {
        FirebaseDatabaseService.shared.acceptPendingFollower(otherId: otherUserId, selfUserId: userId, selfUsername: model.username, selfProfilePicUrl: model.profilePicUrl)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func rejectPendingFollower(otherUserId: String) {
        FirebaseDatabaseService.shared.rejectPendingFollower(selfId: userId, otherId: otherUserId)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func changePrivacy() {
        FirebaseDatabaseService.shared.changePrivacy(userId: userId, newPrivacy: !model.isPrivate)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func updateProfilePicture(image: UIImage) {
        guard let imageData = image.pngData() else {
            print("Error getting image data")
            return
        }
        FirebaseStorageService.shared.updateProfilePic(userId: userId, imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urlString):
                FirebaseDatabaseService.shared.updateProfilePicUrl(userId: self.userId, profilePicUrl: urlString) { success in
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred(intensity: 1.0)
                }
            case .failure(let error):
                print(error.localizedDescription)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
}
