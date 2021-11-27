//
//  FirebaseDatabaseService.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 10/6/21.
//

import Foundation
import FirebaseDatabase

enum DatabaseError: Error {
    case unwrappingFailed
    case downloadUrlFailed
}

let usernamesKey = "usernames"
let usersKey = "users"
let userInfoKey = "userInfo"
let followersKey = "followers"
let followingsKey = "followings"
let poopsKey = "poops"
let pendingFollowersKey = "pendingFollowers"
let pendingRequestsKey = "pendingRequests"
let usernameKey = "username"
let emailKey = "email"
let isPrivateKey = "isPrivate"
let profilePicUrlKey = "profilePicUrl"
let latKey = "lat"
let longKey = "long"
let commentsKey = "comments"
let userIdKey = "userId"

struct FirebaseDatabaseService {
    static var shared = FirebaseDatabaseService()
    
    private var rootRef = Database.database().reference()
    
    func getUsernames(completion: @escaping (Set<String>) -> Void) {
        rootRef.child(usernamesKey).observe(.value) { snapshot in
            let usernamesSet: Set<String> = []
            guard let snapValue = snapshot.value as? [String:String] else {
                completion(usernamesSet)
                return }
            completion(Set(Array(snapValue.values)))
        }
    }
    
    func registerUser(username: String, email: String, uid: String) {
        rootRef.child(usernamesKey).child(uid).setValue(username)
        rootRef.child(userInfoKey).child(uid).setValue([
            usernameKey: username,
            emailKey: email
        ])
        
        rootRef.child(usersKey).child(uid).setValue(
            [
                emailKey: email,
                usernameKey: username,
                isPrivateKey: true
            ]
        )
    }
    
    func pullUserInfo(userId: String, completion: @escaping (Result<AppModel, DatabaseError>) -> Void)  {
        rootRef.child(usersKey).child(userId).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                completion(.failure(.unwrappingFailed))
                return
            }
            var followersIdSet: Set<String> = []
            var followingsIdSet: Set<String> = []
            var pendingFollowersIdSet: Set<String> = []
            var pendingRequestsIdSet: Set<String> = []
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == followersKey {
                    guard let followersDict = snapVal as? [String:Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    followersIdSet = Set(Array(followersDict.keys))
                } else if snapKey == followingsKey {
                    guard let followingsDict = snapVal as? [String:Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    followingsIdSet = Set(Array(followingsDict.keys))
                } else if snapKey == pendingFollowersKey {
                    guard let pendingFollowersDict = snapVal as? [String:Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    pendingFollowersIdSet = Set(Array(pendingFollowersDict.keys))
                } else if snapKey == pendingRequestsKey {
                    guard let pendingRequestsDict = snapVal as? [String:Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    pendingRequestsIdSet = Set(Array(pendingRequestsDict.keys))
                }
            }
            
            let appModel = AppModel(followersIdSet: followersIdSet, followingsIdSet: followingsIdSet, pendingFollowersIdSet: pendingFollowersIdSet, pendingRequestsIdSet: pendingRequestsIdSet)
            completion(.success(appModel))
        }
    }
    
    func pullMapInfo(userId: String, completion: @escaping (Result<MapModel, DatabaseError>) -> Void) {
        rootRef.child(usersKey).child(userId).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(.failure(.unwrappingFailed))
                return }
            
            var username = ""
            var profilePicUrl: String? = nil
            var poops: [PoopModel] = []
            
            for (snapKey, snapValue) in snapDict {
                if snapKey == usernameKey {
                    username = snapValue as! String
                } else if snapKey == profilePicUrlKey {
                    let ppurl = snapValue as! String
                    profilePicUrl = ppurl
                } else if snapKey == poopsKey {
                    
                    guard let usersPoopDict = snapValue as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (poopUserId, userPoopDict) in usersPoopDict {
                        
                        guard let dateTimePoopDicts = userPoopDict as? [String: Any] else {
                            completion(.failure(.unwrappingFailed))
                            return
                        }
                        
                        for (dateTime, poopDict) in dateTimePoopDicts {
                            
                            guard let poopDict = poopDict as? [String: Any] else {
                                completion(.failure(.unwrappingFailed))
                                return
                            }
                            
                            var comments = ""
                            var lat = 0.0
                            var long = 0.0
                            var poopUsername = ""
                            var poopProfilePicUrl: String? = nil
                            
                            for (poopKey, poopValue) in poopDict {
                                if poopKey == commentsKey {
                                    comments = poopValue as! String
                                } else if poopKey == latKey {
                                    lat = poopValue as! Double
                                } else if poopKey == longKey {
                                    long = poopValue as! Double
                                } else if poopKey == usernameKey {
                                    poopUsername = poopValue as! String
                                } else if poopKey == profilePicUrlKey {
                                    let ppurl = poopValue as! String
                                    poopProfilePicUrl = ppurl
                                }
                            }
                            
                            let poop = PoopModel(lat: lat, long: long, comments: comments, dateTime: dateTime, username: poopUsername, userId: poopUserId, profilePicUrl: poopProfilePicUrl)
                            poops.append(poop)
                        }
                    }
                }
            }
            
            let mapModel = MapModel(username: username, profilePicUrl: profilePicUrl, poops: poops)
            completion(.success(mapModel))
            
        }
    }
    
    func deletePin(userId: String, dateTime: String) {
        // First delete poop from own spot in db
        rootRef.child(usersKey).child(userId).child(poopsKey).child(userId).child(dateTime).setValue(nil)
        
        rootRef.child(usersKey).child(userId).child(followersKey).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String: Any] else {
                return
            }
            var followerIds: [String] = []
            followerIds = Array(snapDict.keys)
            
            for followerId in followerIds {
                rootRef.child(usersKey).child(followerId).child(poopsKey).child(userId).child(dateTime).setValue(nil)
            }
        }
    }
    
    func addPin(userId: String, dateTime: String, lat: Double, long: Double, comments: String, username: String, profilePicUrl: String?) {
        // First add poop to our own spot in db
        rootRef.child(usersKey).child(userId).child(poopsKey).child(userId).child(dateTime).setValue(
            [
                latKey: lat,
                longKey: long,
                commentsKey: comments,
                usernameKey: username,
                profilePicUrlKey: profilePicUrl as Any
            ]
        )
        
        // for each follower, add that poop to their spot
        rootRef.child(usersKey).child(userId).child(followersKey).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String: Any] else {
                return
            }
            var followerIds: [String] = []
            followerIds = Array(snapDict.keys)
            
            for followerId in followerIds {
                rootRef.child(usersKey).child(followerId).child(poopsKey).child(userId).child(dateTime).setValue([
                    latKey: lat,
                    longKey: long,
                    commentsKey: comments,
                    usernameKey: username,
                    profilePicUrlKey: profilePicUrl as Any
                ])
            }
        }
    }
    
    func pullProfileInfo(userId: String, completion: @escaping (Result<ProfileModel, DatabaseError>) -> Void) {
        rootRef.child(usersKey).child(userId).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                completion(.failure(.unwrappingFailed))
                return
            }
            var username: String = ""
            var profilePicUrl: String? = nil
            var isPrivate: Bool = false
            var followers: [ListPersonModel] = []
            var followings: [ListPersonModel] = []
            var followerRequests: [ListPersonModel] = []
            var pendingRequests: [ListPersonModel] = []
            var poops: [PoopModel] = []
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == usernameKey {
                    username = snapVal as! String
                } else if snapKey == profilePicUrlKey {
                    let ppurl = snapVal as! String
                    profilePicUrl = ppurl
                } else if snapKey == isPrivateKey {
                    isPrivate = snapVal as! Bool
                } else if snapKey == followersKey {
                    guard let followersDict = snapVal as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (followerId, followerDict) in followersDict {
                        guard let followerInfoDict = followerDict as? [String:Any] else {
                            completion(.failure(.unwrappingFailed))
                            return
                        }
                        var followerUsername = ""
                        var followerProfilePicUrl: String? = nil
                        
                        for (followerKey, followerVal) in followerInfoDict {
                            if followerKey == usernameKey {
                                followerUsername = followerVal as! String
                            } else if followerKey == profilePicUrlKey {
                                let fppurl = followerVal as! String
                                followerProfilePicUrl = fppurl
                            }
                        }
                        
                        let follower = ListPersonModel(userId: followerId, username: followerUsername, profilePicUrl: followerProfilePicUrl)
                        followers.append(follower)
                    }
                } else if snapKey == followingsKey {
                    guard let followingsDict = snapVal as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (followingId, followingsDict) in followingsDict {
                        guard let followingInfoDict = followingsDict as? [String:Any] else {
                            completion(.failure(.unwrappingFailed))
                            return
                        }
                        var followingUsername = ""
                        var followingProfilePicUrl: String? = nil
                        
                        for (followingKey, followingVal) in followingInfoDict {
                            if followingKey == usernameKey {
                                followingUsername = followingVal as! String
                            } else if followingKey == profilePicUrlKey {
                                let fppurl = followingVal as! String
                                followingProfilePicUrl = fppurl
                            }
                        }
                        
                        let following = ListPersonModel(userId: followingId, username: followingUsername, profilePicUrl: followingProfilePicUrl)
                        followings.append(following)
                    }
                } else if snapKey == pendingFollowersKey {
                    guard let followerRequestsDict = snapVal as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (followerRequestId, followerRequestsDict) in followerRequestsDict {
                        guard let followerRequestInfoDict = followerRequestsDict as? [String:Any] else {
                            completion(.failure(.unwrappingFailed))
                            return
                        }
                        var followerRequestUsername = ""
                        var followerRequestProfilePicUrl: String? = nil
                        
                        for (followerRequestKey, followerRequestVal) in followerRequestInfoDict {
                            if followerRequestKey == usernameKey {
                                followerRequestUsername = followerRequestVal as! String
                            } else if followerRequestKey == profilePicUrlKey {
                                let fppurl = followerRequestVal as! String
                                followerRequestProfilePicUrl = fppurl
                            }
                        }
                        
                        let followerRequest = ListPersonModel(userId: followerRequestId, username: followerRequestUsername, profilePicUrl: followerRequestProfilePicUrl)
                        followerRequests.append(followerRequest)
                    }
                } else if snapKey == pendingRequestsKey {
                    guard let pendingRequestsDict = snapVal as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (pendingRequestId, pendingRequestsDict) in pendingRequestsDict {
                        guard let pendingRequestInfoDict = pendingRequestsDict as? [String:Any] else {
                            completion(.failure(.unwrappingFailed))
                            return
                        }
                        var pendingRequestUsername = ""
                        var pendingRequestProfilePicUrl: String? = nil
                        
                        for (pendingRequestKey, pendingRequestVal) in pendingRequestInfoDict {
                            if pendingRequestKey == usernameKey {
                                pendingRequestUsername = pendingRequestVal as! String
                            } else if pendingRequestKey == profilePicUrlKey {
                                let fppurl = pendingRequestVal as! String
                                pendingRequestProfilePicUrl = fppurl
                            }
                        }
                        
                        let pendingRequest = ListPersonModel(userId: pendingRequestId, username: pendingRequestUsername, profilePicUrl: pendingRequestProfilePicUrl)
                        pendingRequests.append(pendingRequest)
                    }
                } else if snapKey == poopsKey {
                    guard let poopDict = snapVal as? [String: Any] else {
                        completion(.failure(.unwrappingFailed))
                        return
                    }
                    
                    for (poopUserId, poopUserDict) in poopDict {
                        if poopUserId == userId {
                            guard let poopTimeDict = poopUserDict as? [String: Any] else {
                                completion(.failure(.unwrappingFailed))
                                return
                            }
                            for (dateTime, individualPoopValues) in poopTimeDict {
                                guard let individualPoopDict = individualPoopValues as? [String:Any] else {
                                    completion(.failure(.unwrappingFailed))
                                    return
                                }
                                var lat: Double = 0.0
                                var long: Double = 0.0
                                var comments: String = ""
                                var poopUsername: String = ""
                                var poopUserId: String = ""
                                var poopProfilePicUrl: String? = nil
                                
                                for (poopKey, poopVal) in individualPoopDict {
                                    if poopKey == latKey {
                                        lat = poopVal as! Double
                                    } else if poopKey == longKey {
                                        long = poopVal as! Double
                                    } else if poopKey == commentsKey {
                                        comments = poopVal as! String
                                    } else if poopKey == usernameKey {
                                        poopUsername = poopVal as! String
                                    } else if poopKey == userIdKey {
                                        poopUserId = poopVal as! String
                                    } else if poopKey == profilePicUrlKey {
                                        let ppurl = poopVal as! String
                                        poopProfilePicUrl = ppurl
                                    }
                                }
                                
                                let poopModel = PoopModel(lat: lat, long: long, comments: comments, dateTime: dateTime, username: poopUsername, userId: poopUserId, profilePicUrl: poopProfilePicUrl)
                                poops.append(poopModel)
                            }
                        }
                    }
                }
            }
            
            let profileModel = ProfileModel(username: username, profilePicUrl: profilePicUrl, isPrivate: isPrivate, followers: followers, followings: followings, followerRequests: followerRequests, pendingRequests: pendingRequests, poops: poops)
            completion(.success(profileModel))
        }
    }
    
    func follow(userSelfId: String, otherId: String, otherUsername: String, otherProfilePicUrl: String?) {
        // adding their poops to our poops
        rootRef.child(usersKey).child(otherId).child(poopsKey).child(otherId).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value {
                    rootRef.child(usersKey).child(userSelfId).child(poopsKey).child(otherId).setValue(value)
                }
            }
        }
        
        // adding their info to our followings
        rootRef.child(usersKey).child(userSelfId).child(followingsKey).child(otherId).setValue([
            usernameKey: otherUsername,
            profilePicUrlKey: otherProfilePicUrl
        ])
        
        // adding our info to their followers
        rootRef.child(usersKey).child(userSelfId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                return
            }
            
            var selfUsername = ""
            var selfProfilePicUrl: String? = nil
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == usernameKey {
                    selfUsername = snapVal as! String
                } else if snapKey == profilePicUrlKey {
                    let ppurl = snapVal as! String
                    selfProfilePicUrl = ppurl
                }
            }
            
            rootRef.child(usersKey).child(otherId).child(followersKey).child(userSelfId).setValue([
                usernameKey: selfUsername,
                profilePicUrlKey: selfProfilePicUrl
            ])
        }
    }
    
    func requestToFollow(userSelfId: String, otherId: String, otherUsername: String, otherProfilePicUrl: String?) {
        // adding their info to our pendingRequests
        rootRef.child(usersKey).child(userSelfId).child(pendingRequestsKey).child(otherId).setValue([
            usernameKey: otherUsername,
            profilePicUrlKey: otherProfilePicUrl
        ])
        
        // adding our info to their pendingFollowers
        rootRef.child(usersKey).child(userSelfId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                return
            }
            
            var selfUsername = ""
            var selfProfilePicUrl: String? = nil
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == usernameKey {
                    selfUsername = snapVal as! String
                } else if snapKey == profilePicUrlKey {
                    let ppurl = snapVal as! String
                    selfProfilePicUrl = ppurl
                }
            }
            
            rootRef.child(usersKey).child(otherId).child(pendingFollowersKey).child(userSelfId).setValue([
                usernameKey: selfUsername,
                profilePicUrlKey: selfProfilePicUrl
            ])
        }
    }
    
    func unfollow(selfId: String, otherId: String) {
        rootRef.child(usersKey).child(selfId).child(followingsKey).child(otherId).setValue(nil)
        rootRef.child(usersKey).child(selfId).child(poopsKey).child(otherId).setValue(nil)
        rootRef.child(usersKey).child(otherId).child(followersKey).child(selfId).setValue(nil)
    }
    
    func cancelFollowRequest(selfId: String, otherId: String) {
        rootRef.child(usersKey).child(selfId).child(pendingRequestsKey).child(otherId).setValue(nil)
        rootRef.child(usersKey).child(otherId).child(pendingFollowersKey).child(selfId).setValue(nil)
    }
    
    func acceptPendingFollower(otherId: String, selfUserId: String, selfUsername: String, selfProfilePicUrl: String?) {
        cancelFollowRequest(selfId: otherId, otherId: selfUserId)
        follow(userSelfId: otherId, otherId: selfUserId, otherUsername: selfUsername, otherProfilePicUrl: selfProfilePicUrl)
    }
    
    func rejectPendingFollower(selfId: String, otherId: String) {
        cancelFollowRequest(selfId: otherId, otherId: selfId)
    }
    
    func updateProfilePicUrl(userId: String, profilePicUrl: String, completion: @escaping (Bool) -> Void) {
        rootRef.child(usersKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
        rootRef.child(userInfoKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
        
        // in the user's own poops
        rootRef.child(usersKey).child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String: Any] else {
                return
            }
            
            var userPoops: [String] = []
            var followerIds: [String] = []
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == poopsKey {
                    guard let usersPoopsDict = snapVal as? [String: Any] else {
                        completion(false)
                        return
                    }
                    if let userPoopDict = usersPoopsDict[userId] as? [String:Any] {
                        userPoops = Array(userPoopDict.keys)
                    }
                } else if snapKey == followersKey {
                    guard let followersDict = snapVal as? [String: Any] else {
                        completion(false)
                        return
                    }
                    for followerId in followersDict.keys {
                        rootRef.child(usersKey).child(followerId).child(followingsKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
                    }
                    followerIds = Array(followersDict.keys)
                } else if snapKey == followingsKey {
                    guard let followingsDict = snapVal as? [String: Any] else {
                        completion(false)
                        return
                    }
                    for followingId in followingsDict.keys {
                        rootRef.child(usersKey).child(followingId).child(followersKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
                    }
                } else if snapKey == pendingFollowersKey {
                    guard let followerRequestsDict = snapVal as? [String: Any] else {
                        completion(false)
                        return
                    }
                    for followerRequestId in followerRequestsDict.keys {
                        rootRef.child(usersKey).child(followerRequestId).child(pendingRequestsKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
                    }
                } else if snapKey == pendingRequestsKey {
                    guard let pendingRequestsDict = snapVal as? [String: Any] else {
                        completion(false)
                        return
                    }
                    for pendingRequestId in pendingRequestsDict.keys {
                        rootRef.child(usersKey).child(pendingRequestId).child(pendingFollowersKey).child(userId).child(profilePicUrlKey).setValue(profilePicUrl)
                    }
                }
            }
            
            for userPoop in userPoops {
                rootRef.child(usersKey).child(userId).child(poopsKey).child(userId).child(userPoop).child(profilePicUrlKey).setValue(profilePicUrl)
                
                // for each follower, update each poop
                for followerId in followerIds {
                    rootRef.child(usersKey).child(followerId).child(poopsKey).child(userId).child(userPoop).child(profilePicUrlKey).setValue(profilePicUrl)
                }
            }
        }
        completion(true)
    }
    
    func changePrivacy(userId: String, newPrivacy: Bool) {
        rootRef.child(usersKey).child(userId).child(isPrivateKey).setValue(newPrivacy)
    }
    
    func pullSearchInfo(completion: @escaping (Result<SearchModel, DatabaseError>) -> Void) {
        rootRef.child(userInfoKey).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                completion(.failure(.unwrappingFailed))
                return
            }
            
            var users: [UserSearchModel] = []
            
            for (userId, userInfo) in snapDict {
                guard let userInfo = userInfo as? [String: Any] else {
                    completion(.failure(.unwrappingFailed))
                    return
                }
            
                var username = ""
                var email = ""
                var profilePicUrl: String? = nil
                
                for (userInfoKey, userInfoVal) in userInfo {
                    if userInfoKey == usernameKey {
                        username = userInfoVal as! String
                    } else if userInfoKey == emailKey {
                        email = userInfoVal as! String
                    } else if userInfoKey == profilePicUrlKey {
                        let ppurl = userInfoVal as! String
                        profilePicUrl = ppurl
                    }
                }
                
                let user = UserSearchModel(userId: userId, username: username, email: email, profilePicUrl: profilePicUrl)
                users.append(user)
            }
            let searchModel = SearchModel(users: users)
            completion(.success(searchModel))
        }
    }
}
