//
//  ProfileImageView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/19/21.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    var username: String
    var profilePicUrl: String?
    
    var body: some View {
        if let profilePicUrl = profilePicUrl {
            KFImage(URL(string: profilePicUrl)!)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .cornerRadius(45)
                .overlay(Circle().stroke(.secondary, lineWidth: 2))
        } else {
            ZStack {
                Circle()
                    .fill(.gray)
                    .opacity(50)
                    .overlay(Circle().stroke(.secondary, lineWidth: 2))
                    .frame(width: 90, height: 90)
                Text("\(String(username.first!))")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(username: "T ", profilePicUrl: "https://firebasestorage.googleapis.com:443/v0/b/crap-tracker-f3cc2.appspot.com/o/userProfilePics%2Fi066sKE6tLg9n53uttB4JSkKlFu1%2FprofilePic.png?alt=media&token=d72e404c-fca1-42d6-8314-d8ecaa23842d")
    }
}
