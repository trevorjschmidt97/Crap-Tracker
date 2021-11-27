//
//  EmailTextField.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        TextField("email", text: $email)
            .font(.caption)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
    }
}

//struct EmailTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        EmailTextField()
//    }
//}
