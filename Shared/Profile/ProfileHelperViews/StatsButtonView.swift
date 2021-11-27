//
//  StatsButtonView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/19/21.
//

import SwiftUI

struct StatsButtonView: View {
    var count: Int
    @Binding var contentState: ContentState
    var selfState: ContentState
    
    var body: some View {
        VStack {
            Button("\(count)") {
                contentState = selfState
            }
            Text(selfState == .craps ? "Pins" : selfState == .followers ? count == 1 ? "Follower" : "Followers" : "Following")
        }
            .font(contentState == selfState ? .headline : .body)
    }
}

//struct StatsButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsButtonView()
//    }
//}
