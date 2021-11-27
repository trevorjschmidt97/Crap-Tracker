//
//  ProfileModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation

struct ProfileModel {
    var username: String = " "
    var profilePicUrl: String? = nil
    var isPrivate: Bool = false
    var followers: [ListPersonModel] = []
    var followings: [ListPersonModel] = []
    var followerRequests: [ListPersonModel] = []
    var pendingRequests: [ListPersonModel] = []
    var poops: [PoopModel] = []
}

struct ListPersonModel: Identifiable {
    var id: String {
        userId
    }
    var userId: String
    var username: String
    var profilePicUrl: String?
}
