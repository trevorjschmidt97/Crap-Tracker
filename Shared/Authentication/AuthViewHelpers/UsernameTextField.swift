//
//  UsernameTextField.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("username", text: $username)
            .font(.caption)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .submitLabel(.next)
    }
}

//struct UsernameTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        UsernameTextField()
//    }
//}
