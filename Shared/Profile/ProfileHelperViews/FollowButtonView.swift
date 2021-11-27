//
//  FollowButtonView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/19/21.
//

import SwiftUI

struct FollowButtonView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var profileState: ProfileState
    @Binding var settingsButtonPressed: Bool
    @Binding var followingButtonPressed: Bool
    @Binding var requestedButtonPressed: Bool
    
    var body: some View {
        Button {
            if profileState == .userSelf {
                settingsButtonPressed.toggle()
            } else if profileState == .following {
                followingButtonPressed.toggle()
            } else if profileState == .requested {
                requestedButtonPressed.toggle()
            } else {
                viewModel.follow()
            }
        } label: {
            HStack {
                Spacer()
                Text("\(profileState == .userSelf ? "Settings" : profileState == .following ? "Following" : profileState == .requested ? "Requested" : profileState == .follower ? "Follow Back" : "Follow")")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.horizontal, 2)
                Spacer()
            }
            .padding(2)
            .background(Color("AccentColor"))
            .cornerRadius(5)
            .shadow(radius: 1)
        }
    }
}

//struct FollowButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowButtonView()
//    }
//}
