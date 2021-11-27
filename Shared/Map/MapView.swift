//
//  MapView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import SwiftUI

struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State private var textFieldAlertIsPresented = false
    @State private var title = ""
    
    var body: some View {
        ZStack {
            MapKitView(manager: locationManager, poops: viewModel.model.poops)
            
            Image(systemName: "hand.point.down")
                .font(.title)
                .padding(.bottom, 30)
                .padding(.trailing, 5)
            
            VStack {
                Spacer()
                Button {
                    textFieldAlertIsPresented = true
                } label: {
                    DropPinButton()
                }
            }
        }
            .textFieldAlert(isPresented: $textFieldAlertIsPresented, title: "Leave a Comment", text: title, placeholder: "...", action: { comments in
                guard let comments = comments else {
                    print("error unwrapping text optional from textFieldAlert")
                    return
                }
                viewModel.addPinToDataBase(comments: comments,
                                           lat: locationManager.region.center.latitude,
                                           long: locationManager.region.center.longitude)
            })
            .navigationTitle("Map")
            .onAppear {
                viewModel.onAppear()
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
