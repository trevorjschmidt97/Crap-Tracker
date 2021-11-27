//
//  UsernameTakenView.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct UsernameTakenView: View {
    var body: some View {
        HStack {
            Text("Username is taken, please choose another")
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct UsernameTakenView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameTakenView()
    }
}
