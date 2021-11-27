//
//  MapViewModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation
import SwiftUI

class MapViewModel: ObservableObject {
    
    @Published var model = MapModel()
    
    func onAppear() {
        let userId = FirebaseAuthService.shared.getUserId()
        guard let userId = userId else {
            print("Error unwrapping userID in map's onAppear")
            return
        }
        
        FirebaseDatabaseService.shared.pullMapInfo(userId: userId) { [weak self] result in
            switch result {
            case.success(let mapModel):
                self?.model = mapModel
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func addPinToDataBase(comments: String, lat: Double, long: Double) {
        let dateTime = Date().toLongString()
        let username = model.username
        let profilePicUrl = model.profilePicUrl
        let userId = FirebaseAuthService.shared.getUserId()
        guard let userId = userId else {
            print("Error unwrapping userID in addingPinToDb")
            return
        }
        // Now we have all the info we need
        
        FirebaseDatabaseService.shared.addPin(userId: userId, dateTime: dateTime, lat: lat, long: long, comments: comments, username: username, profilePicUrl: profilePicUrl)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
}
