//
//  SignUpView.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @FocusState private var focusedField: Focus?
    
    var body: some View {
        ScrollView {
            VStack {
                LogoView()
                UsernameTextField(username: $viewModel.signUpModel.username)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .username)
                    .onSubmit {
                        focusedField = .email
                    }
                if viewModel.usernamesSet.contains(viewModel.signUpModel.username) {
                    UsernameTakenView()
                }
                EmailTextField(email: $viewModel.signUpModel.email)
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    .textContentType(.username)
                PasswordSecureField(password: $viewModel.signUpModel.password)
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        viewModel.signUpPressed()
                    }
                    .textContentType(.newPassword)
                Button {
                    viewModel.signUpPressed()
                } label: {
                    RegisterButton()
                }
                .padding(.vertical, 6)
            }
        }
        .onAppear {
            viewModel.pullUsernames()
        }
        .navigationTitle("Sign Up")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: selectPreviousField) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canSelectPreviousField)
                
                Button(action: selectNextField) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canSelectNextField)
                
                Spacer()
                
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

extension SignUpView {
    private enum Focus: Int, Hashable {
        case username, email, password
    }
    
    private func selectPreviousField() {
        focusedField = focusedField.map {
            Focus(rawValue: $0.rawValue - 1) ?? .email
        }
    }
    
    private func selectNextField() {
        focusedField = focusedField.map {
            Focus(rawValue: $0.rawValue + 1) ?? .password
        }
    }
    
    private var canSelectPreviousField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue > 0
        }
        return false
    }
    
    private var canSelectNextField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue < 2
        }
        return false
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
