//
//  SignInView.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/29/21.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    @FocusState private var focusedField: Focus?
    
    var body: some View {
        ScrollView {
            VStack {
                LogoView()
                
                EmailTextField(email: $viewModel.signInModel.email)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    .textContentType(.username)
                
                if viewModel.signInModel.email.count > 0 {
                    ForgotPasswordButton(viewModel: viewModel)
                }
                
                PasswordSecureField(password: $viewModel.signInModel.password)
                    .padding(.horizontal)
                    .padding(.top, 6)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = nil
                        viewModel.signInPressed()
                    }
                    .textContentType(.password)
                
                Button {
                    viewModel.signInPressed()
                } label: {
                    LogInButton()
                }
                
                NavigationLink("Don't Have An Account?") {
                    SignUpView(viewModel: viewModel)
                }
                .padding()
                
            }
        }
            .navigationTitle("Welcome")
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

extension SignInView {
    private enum Focus: Int, Hashable {
        case email, password
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
            return currentFocusedField.rawValue < 1
        }
        return false
    }
}





struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}
