//
//  AppModel.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 10/20/21.
//

import Foundation

struct AppModel {
    var followersIdSet: Set<String> = []
    var followingsIdSet: Set<String> = []
    var pendingFollowersIdSet: Set<String> = []
    var pendingRequestsIdSet: Set<String> = []
}
