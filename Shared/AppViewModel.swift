//
//  AppViewModel.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import Foundation

class AppViewModel: ObservableObject {
    static var shared = AppViewModel()
    
    @Published var isSignedIn = false
    @Published var alertShowing = false
    var alertTitle = ""
    var alertMessage = ""
    @Published var model = AppModel()
    
    func checkSignIn() {
        isSignedIn = FirebaseAuthService.shared.checkSignIn()
    }
    
    func pullUserInfo() {
        if let userId = FirebaseAuthService.shared.getUserId() {
            FirebaseDatabaseService.shared.pullUserInfo(userId: userId) { [weak self] result in
                switch result {
                case .success(let appModel):
                    self?.model = appModel
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func signOut() {
        isSignedIn = !FirebaseAuthService.shared.signOut()
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        alertShowing = true
    }
}
