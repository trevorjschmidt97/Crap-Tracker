//
//  PasswordSecureField.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct PasswordSecureField: View {
    @Binding var password: String
    
    var body: some View {
        SecureField("password", text: $password)
            .font(.caption)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .submitLabel(.next)
            .padding(.bottom)
    }
}

//struct PasswordTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordSecureField()
//    }
//}
