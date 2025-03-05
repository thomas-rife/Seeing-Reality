//
//  Navigation.swift
//  NavigationAp
//
//  Created by August Wetterau on 3/7/21.
//

import SwiftUI
import MapKit
import Combine
import Foundation
import AVFoundation
import UIKit

struct Navigation: View {
    
    @State private var search: String = ""
    @State private var landmarks: [Landmark] = [Landmark]()
    @ObservedObject var locationManager = LocationManager()
    @State private var tapped: Bool = false
    @EnvironmentObject var constants : Constants
    private let completer = MKLocalSearchCompleter()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var colorss : Colors
    
    
    
    private func getNearByLandmarks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                
                
            }
        }
        
    }
    
    func calculateOffset() -> CGFloat {
        if self.landmarks.count > 0 && !self.tapped {
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 6.5
        }  else if self.tapped {
            return 500
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    var body: some View {
        ZStack() {
        ZStack(alignment: .top) {
            
            MapView(landmarks: landmarks).ignoresSafeArea(.all)
            
            
            if constants.isRouting {
                Text(constants.currentDirection).frame(width: UIScreen.main.bounds.size.width-50, height: 100, alignment: .center).multilineTextAlignment(.center).background(Rectangle().cornerRadius(20).frame(width: UIScreen.main.bounds.size.width-30, height: 100).foregroundColor(.black)).offset(y: 50)
            } else {
                TextField("Search", text: $search, onEditingChanged: {
                    _ in

                }) {
                    constants.isChoosing = true
                    constants.isRouting = false
                    
                    self.getNearByLandmarks()
                }.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .offset(y: 44)
                
                .foregroundColor(colorss.BgColor)
                
                
            }
            
            
            PlaceListView(landmarks: self.landmarks) {
                self.tapped.toggle()
            }.animation(.spring()).offset(y: calculateOffset())
        }
            Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "arrow.left.circle").foregroundColor(colorss.FgColor)
                    Text("Back").foregroundColor(colorss.FgColor)
                }
            }.offset(x: -165, y: -380)
        }.navigationBarHidden(true).navigationBarBackButtonHidden(false)
    
        }
    
}

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var constants: Constants
    let landmarks: [Landmark]

    @State var stepCounter = 0
    

    
    
    public let mapView = MKMapView()
    
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        

    
        return map
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
        
        if (constants.personView) {
            
            uiView.userTrackingMode = .followWithHeading
            
            uiView.isUserInteractionEnabled = false
        } else {
            uiView.isUserInteractionEnabled = true
            uiView.userTrackingMode = .none
        }
        
        if constants.viewType {
            uiView.mapType = .hybrid
        } else {
            uiView.mapType = .standard
        }
      
        if (constants.isRouting == true ) {
            
            
         
            if (constants.changingAnnotations) {
                
                uiView.removeAnnotations(uiView.annotations)
                uiView.removeOverlays(uiView.overlays)
                uiView.addAnnotation(constants.destinationAnnotation)
                removeAnnotations(from: uiView)
                constants.changingAnnotations = false
                
            }
        
           
            
            
            
        } else {
            if constants.isChoosing {
                
                uiView.setCenter(uiView.userLocation.location!.coordinate, animated: true)
               
                uiView.setRegion(MKCoordinateRegion(center: uiView.userLocation.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
          
            
                constants.isChoosing = false
            }
            updateAnnotations(from: uiView)
          
        }
        
       
        
    }
    func speak(_ text: String)  {
    let voice = AVSpeechSynthesisVoice(language: "en-US")
    
    let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = 0.5
    
    let synthesizer = AVSpeechSynthesizer()
        
        synthesizer.speak(utterance)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
       
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let annotations = self.landmarks.map(LandmarkAnnotation.init)
        mapView.addAnnotations(annotations)
    }
    private func removeAnnotations(from mapView: MKMapView) {
        
        //Make The Request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: mapView.userLocation.location!.coordinate.latitude, longitude: mapView.userLocation.location!.coordinate.longitude)))
        request.destination = MKMapItem(placemark: constants.destinationAnnotation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
 
        
        
        
        //Draw directions
        let directions = MKDirections(request: request)
        let group = DispatchGroup()
        
        directions.calculate { (response, error) in
        
            if (error == nil) {
                
            group.enter()
                let route = response!
                let sortedRoutes = route.routes.sorted(by: { $0.distance > $1.distance })
                var index = 0
                constants.currentRoute = route
        
                           for route in sortedRoutes {
                               
                               if index == sortedRoutes.count-1{
                                   route.polyline.title = "shortest"
                                route.polyline.subtitle = "Selected"
                                
                               }
                               index += 1
                            mapView.addOverlay(route.polyline)
                            
                            mapView.setVisibleMapRect(route.polyline.boundingMapRect,edgePadding: UIEdgeInsets(top: 200, left: 70, bottom: 70, right: 70), animated: true)
                            
                           
                            constants.directions = route.steps
                            print(constants.directions)
                            for i in 0 ..< route.steps.count {
                                let step = route.steps[i]
                                print(step.instructions)
                                print(step.distance)
                                let region = CLCircularRegion(center: step.polyline.coordinate,
                                                              radius: 20,
                                                              identifier: "\(i)")
                                CLLocationManager().startMonitoring(for: region)
                               
                                
                            }
                            
                            let initialMessage = "In \(Int(constants.directions[1].distance)) meters, \(constants.directions[1].instructions.description) then in \(Int(constants.directions[2].distance)) meters, \(constants.directions[2].instructions)."
                            speak(initialMessage)
                            constants.currentDirection = initialMessage
                           
                            self.stepCounter += 1
                            
                           
                           }
               
                group.leave()
            
            }
            group.wait()
          
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED")
        stepCounter += 1
        if stepCounter < constants.directions.count {
            let currentStep = constants.directions[stepCounter]
            let message = "In \(currentStep.distance) meters, \(currentStep.instructions)"
            constants.currentDirection = message
        } else {
            let message = "Arrived at destination"
            constants.currentDirection = message
            stepCounter = 0
            CLLocationManager().monitoredRegions.forEach({ CLLocationManager().stopMonitoring(for: $0) })
            
        }
    }
    
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}

struct Landmark {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(landmark: Landmark) {
        self.title = landmark.name
        self.coordinate = landmark.coordinate
    }
    
}

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    
    
    var control: MapView
    
    
    init(_ control: MapView) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(overlay: overlay)
        
            if polyline.subtitle == "Selected"{
                renderer.strokeColor = UIColor.blue
                }else{
                    renderer.strokeColor = UIColor.lightGray
                    
                }
        
            
            return renderer
        }

    
}

class Constants: ObservableObject {
    @Published public var isRouting = false
    @Published public var directions = [MKRoute.Step]()
    @Published public var currentDirection = ""
    @Published public var showDirections = false
    @Published public var destination: MKPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.78583400, longitude: -122.40641700))
    @Published var destinationAnnotation = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.78583400, longitude: -122.40641700))
    @Published var changingAnnotations = true
    @Published var isChoosing = false
    @Published var viewType =  false
    @Published var personView = false
    @Published var currentRoute = MKDirections.Response()
    @Published var offset: CGFloat = -165
}



struct PlaceListView: View {
    @EnvironmentObject var colorss : Colors
    
    let landmarks: [Landmark]
    var onTap: () -> ()
    
    @EnvironmentObject var constants : Constants
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
            Button(action: {
                constants.personView.toggle()
            }) {
      
                ZStack() {
                    Circle()
                        .stroke(colorss.FgColor,lineWidth: 2)
                        .frame(width: 50, height: 50)
                        .fixedSize()
                    Circle()
                        .foregroundColor(colorss.BgColor)
                        
                        .frame(width: 45, height: 45)
                        .fixedSize()
                
                    if !constants.personView {
                        Image(systemName: "location").foregroundColor(colorss.FgColor)
                    } else {
                        Image(systemName: "location.fill").foregroundColor(colorss.FgColor)
                    }
                
                    
            }
                
            }.offset(x: constants.offset)
            
                if constants.isRouting {
                    Button(action: {
                        constants.isRouting = false
                        constants.offset = -165
                    }) {
                        Text("END").font(.system(size: 30)).foregroundColor(.white).bold().background(Rectangle().foregroundColor(.red).cornerRadius(10).frame(width: 70, height: 40))
                        
                    }.offset(x: 120)
                }
            }
            HStack {
                ZStack {
                    EmptyView()
                    HStack() {
                        
                    
                    }
                    
                }
               
                    .frame(width: UIScreen.main.bounds.size.width, height: 60)
                .background(RoundedCorners(tl: 25, tr: 25, bl: 0, br: 0).fill(colorss.FgColor))
                    
                    .gesture(TapGesture().onEnded(self.onTap))
                
            }
            
            if constants.isRouting {

                List {
                    Text(constants.currentDirection)
                    ForEach(constants.directions, id: \.self) { direction in
                        Text("\(direction.instructions) in \(direction.distance) meters")
                    }
                    
                }
            } else {
            List {
    
                
                ForEach(self.landmarks, id: \.id) { landmark in
                    
                    Button(action: {
                        onTap()
                        constants.changingAnnotations = true
                        
                        constants.destinationAnnotation = landmark.placemark
                        constants.isRouting = true
                        constants.offset = -125
              
                        
                    }) {
                        VStack(alignment: .leading) {
                            Text(landmark.name).fontWeight(.bold)
                            
                            Text(landmark.title)
                        }
                    }
                    }
                    
            }.animation(nil)
            }
                
        }.cornerRadius(10)
            
            
            }
        }

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView(landmarks: [Landmark(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 100, longitude: 100), addressDictionary: ["Place1": 1]))], onTap: {})
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

