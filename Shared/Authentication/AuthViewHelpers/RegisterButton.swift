//
//  RegisterButton.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct RegisterButton: View {
    var body: some View {
        Text("REGISTER")
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(width: 200, height: 60)
            .background(Color("AccentColor"))
            .cornerRadius(30)
    }
}

struct RegisterButton_Previews: PreviewProvider {
    static var previews: some View {
        RegisterButton()
    }
}
