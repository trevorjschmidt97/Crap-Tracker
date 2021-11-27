//
//  Crap_TrackerApp.swift
//  Shared
//
//  Created by Trevor Schmidt on 9/28/21.
//

import SwiftUI
import Firebase

@main
struct Crap_TrackerApp: App {
    @StateObject var viewModel = AppViewModel.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color("AccentColor"))
                .accentColor(Color("AccentColor"))
                .onAppear {
                    viewModel.checkSignIn()
                }
                .alert(isPresented: $viewModel.alertShowing) {
                    Alert(title: Text(viewModel.alertTitle),
                          message: Text(viewModel.alertMessage),
                          dismissButton: .default(Text("Okay")))
                }
        }
    }
}
