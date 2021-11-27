//
//  SearchModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation

struct SearchModel {
    var users: [UserSearchModel] = []
}

struct UserSearchModel: Identifiable {
    var id: String {
        userId
    }
    var userId: String
    var username: String
    var email: String
    var profilePicUrl: String?
}
