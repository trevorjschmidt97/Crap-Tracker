//
//  DropPinButton.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import SwiftUI

struct DropPinButton: View {
    
    static var randomPoopString: String = {
        [
            "Make A Splash"
//            "Drop A Pin",
//            "Bombs Away",
//            "Bake a Loaf",
//            "Bomb the Bowl",
//            "Chop a Log",
//            "Crap"
        ].randomElement()!
    }()
    
    var body: some View {
        HStack {
            Text("💩")
                .font(.title)
            Text(DropPinButton.randomPoopString)
                .foregroundColor(Color("AccentColor"))
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 2)
            Text("💩")
                .font(.title)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(30)
        .shadow(radius: 10)
        .padding()
    }
}

struct DropPinButton_Previews: PreviewProvider {
    static var previews: some View {
        DropPinButton()
    }
}
