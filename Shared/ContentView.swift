//
//  ContentView.swift
//  Shared
//
//  Created by Trevor Schmidt on 9/28/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var viewModel = AppViewModel.shared
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color("AccentColor"))]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color("AccentColor"))]
    }
    
    var body: some View {
        
        if viewModel.isSignedIn {
            TabView {
                // Map
                NavigationView {
                    MapView()
                }
                    .tag(0)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                
                // Profile
                NavigationView {
                    ProfileView(userId: FirebaseAuthService.shared.getUserId() ?? "")
                }
                    .tag(1)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                
                // Search
                NavigationView {
                    SearchView()
                }
                    .tag(2)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
            }
                .onAppear {
                    viewModel.pullUserInfo()
                }
        } else {
            NavigationView {
                SignInView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        
            
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
