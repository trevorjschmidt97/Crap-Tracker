//
//  MapModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation

struct MapModel {
    var username: String = ""
    var profilePicUrl: String?
    var poops: [PoopModel] = []
}

struct PoopModel: Identifiable {
    var id: String {
        userId + dateTime
    }
    var lat: Double
    var long: Double
    var comments: String
    var dateTime: String
    var username: String
    var userId: String
    var profilePicUrl: String?
}
