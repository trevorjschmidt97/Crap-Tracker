//
//  LogoView.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .padding(.top, 20)
            .padding(.bottom, 40)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
