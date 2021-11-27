//
//  AuthenticationViewModel.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import Foundation
import UIKit

class AuthenticationViewModel: ObservableObject {
    @Published var signInModel = SignInModel()
    @Published var signUpModel = SignUpModel()
    @Published var usernamesSet: Set<String> = []
    
    func forgotPasswordPressed() {
        FirebaseAuthService.shared.forgotPassword(email: signInModel.email) { result in
            switch result {
            case .success(let email):
                AppViewModel.shared.showAlert(title: "Nice", message: "An email was sent to \(email) with a link to reset the password")
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred(intensity: 1.0)
            case .failure(let error):
                AppViewModel.shared.showAlert(title: "Error", message: "\(error.localizedDescription)")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
    
    func signInPressed() {
        FirebaseAuthService.shared.signIn(email: signInModel.email, password: signInModel.password) { success in
            if success {
                AppViewModel.shared.isSignedIn = true
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred(intensity: 1.0)
            } else {
                AppViewModel.shared.showAlert(title: "Error", message: "Error signing in, try again later")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
    
    func pullUsernames() {
        FirebaseDatabaseService.shared.getUsernames { [weak self] usernamesSet in
            print(usernamesSet)
            self?.usernamesSet = usernamesSet
        }
    }
    
    func signUpPressed() {
        if signUpModel.username.count < 1 {
            AppViewModel.shared.showAlert(title: "Error", message: "A Username is Required")
            return
        }
        
        if usernamesSet.contains(signUpModel.username) {
            AppViewModel.shared.showAlert(title: "Error", message: "A Different Username is Required")
            return
        }
        
        if signUpModel.email.count < 1 {
            AppViewModel.shared.showAlert(title: "Error", message: "An Email is Required")
            return
        }
        
        if signUpModel.password.count < 6 {
            AppViewModel.shared.showAlert(title: "Error", message: "Password Must Be At Least 6 Characters")
            return
        }
        
        FirebaseAuthService.shared.signUp(email: signUpModel.email, password: signUpModel.password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let uid):
                FirebaseDatabaseService.shared.registerUser(username: self.signUpModel.username, email: self.signUpModel.email, uid: uid)
                AppViewModel.shared.isSignedIn = true
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred(intensity: 1.0)
            case .failure(let error):
                print("error \(error.localizedDescription)")
                AppViewModel.shared.showAlert(title: "Error", message: "\(error.localizedDescription)")
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
        
    }
    
}
