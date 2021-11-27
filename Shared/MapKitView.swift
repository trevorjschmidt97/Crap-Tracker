//
//  MapKitView.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import SwiftUI
import MapKit
import CoreLocation
import Kingfisher

struct MapKitView: View {
    @ObservedObject var manager: LocationManager
    var poops: [PoopModel]
    var fromProfile = false
    @State private var commentsAlertIsPresented = false
    @State private var clickedUsername = ""
    @State private var clickedComments = ""
    @State private var clickedFormattedDateTime = ""
    @State private var clickedUserId = ""
    @State private var clickedDateTime = ""
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: poops) { poop in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: poop.lat, longitude: poop.long)) {
                Button {
                    clickedUserId = poop.userId
                    clickedUsername = poop.username
                    clickedComments = poop.comments
                    clickedFormattedDateTime = poop.dateTime.fromLongToShort()
                    clickedDateTime = poop.dateTime
                    commentsAlertIsPresented.toggle()
                } label: {
                    if let profilePicUrl = poop.profilePicUrl {
                        KFImage(URL(string: profilePicUrl)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                            .overlay(Circle().stroke(.white, lineWidth: 2))
                    } else {
                        ZStack {
                            Circle()
                                .fill(.gray)
                                .opacity(50)
                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                .shadow(radius: 20)
                                .frame(width: 40, height: 40)
                            Text("\(String(poop.username.first!))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }
        }
        .onAppear {
            // Change map region, only if viewing from profile
            if fromProfile {
                if poops.count > 0 {
                    // Change region
                    var maxLatitude = -1000.00
                    var maxLongitude = -1000.00
                    var minLatitude = 1000.00
                    var minLongitude = 1000.00
                    
                    poops.forEach { poop in
                        if maxLatitude < poop.lat { maxLatitude = poop.lat }
                        if maxLongitude < poop.long { maxLongitude = poop.long }
                        if minLatitude > poop.lat { minLatitude = poop.lat }
                        if minLongitude > poop.long { minLongitude = poop.long }
                    }
                    
                    manager.region.center.latitude = minLatitude + (maxLatitude - minLatitude) / 2
                    manager.region.center.longitude = minLongitude + (maxLongitude - minLongitude) / 2
                    manager.region.span.latitudeDelta = (maxLatitude - minLatitude) * 1.2
                    manager.region.span.longitudeDelta = (maxLongitude - minLongitude) * 1.2
                }
            }
        }
        .alert(isPresented: $commentsAlertIsPresented, content: {
            
            if let userId = FirebaseAuthService.shared.getUserId(), userId == clickedUserId {
                return Alert(title: Text("\(clickedUsername)"),
                             message: Text("\(clickedFormattedDateTime)\n\n\(clickedComments)"),
                             primaryButton: .default(Text("Nice!")),
                             secondaryButton: .destructive(Text("Delete")) {
                                FirebaseDatabaseService.shared.deletePin(userId: userId, dateTime: clickedDateTime)
                            }
                      )
            } else {
                return Alert(title: Text("\(clickedUsername)"),
                      message: Text("\(clickedFormattedDateTime)\n\n\(clickedComments)"),
                      dismissButton: .default(Text("Nice!")))
            }
            
            
        })
    }
    
}

class LocationManager: NSObject,CLLocationManagerDelegate, ObservableObject {
    @Published var region = MKCoordinateRegion()
    private let manager = CLLocationManager()
    
    private var loaded = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !loaded {
            locations.last.map {
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
            }
        }
        loaded = true
    }
    
    
}

//struct MapKitView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapKitView()
//    }
//}
