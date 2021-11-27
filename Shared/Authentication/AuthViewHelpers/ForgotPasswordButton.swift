//
//  ForgotPasswordButton.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct ForgotPasswordButton: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    var body: some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                viewModel.forgotPasswordPressed()
            }
            .padding(.horizontal)
        }
    }
}

//struct ForgotPasswordButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ForgotPasswordButton()
//    }
//}
