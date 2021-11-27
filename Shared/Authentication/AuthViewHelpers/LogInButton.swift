//
//  LogInButton.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct LogInButton: View {
    var body: some View {
        Text("LOG IN")
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(width: 200, height: 60)
            .background(Color("AccentColor"))
            .cornerRadius(30)
    }
}

struct LogInButton_Previews: PreviewProvider {
    static var previews: some View {
        LogInButton()
    }
}
