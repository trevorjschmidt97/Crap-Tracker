//
//  FirebaseStorageService.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/20/21.
//

import Foundation
import FirebaseStorage

struct FirebaseStorageService {
    static var shared = FirebaseStorageService()
    
    let rootRef = Storage.storage().reference()
    
    func updateProfilePic(userId: String, imageData: Data, completion: @escaping (Result<String, DatabaseError>) -> Void) {
        
        rootRef.child("userProfilePics").child(userId).child("profilePic.png").putData(imageData, metadata: nil) { metaData, error in
            guard metaData != nil, error == nil else {
                completion(.failure(.downloadUrlFailed))
                return
            }
            rootRef.child("userProfilePics").child(userId).child("profilePic.png").downloadURL { url, error in
                guard error == nil else {
                    completion(.failure(.downloadUrlFailed))
                    return
                }
                guard let url = url else {
                    completion(.failure(.downloadUrlFailed))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
    }
}
