//
//  FirebaseAuthService.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthService {
    static var shared = FirebaseAuthService()
    
    var auth = Auth.auth()
    
    func checkSignIn() -> Bool {
        if auth.currentUser == nil {
            return false
        }
        return true
    }
    
    func getUserId() -> String? {
        auth.currentUser?.uid
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void){
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("Error signing in")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("error in password reset \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            completion(.success(email))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error, result == nil {
                print("error in sign up")
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result.user.uid))
            }
        }
    }
    
    func signOut() -> Bool {
        do {
            try auth.signOut()
        } catch {
            return false
        }
        return true
    }
}
