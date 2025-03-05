//
//  ContentView.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/18/21.
//

import SwiftUI
import MapKit

class Colors: ObservableObject {
    @Published public var BgColor = Color(red: 200 / 255,green: 200 / 255,blue: 200 / 255)
    
    @Published public var FgColor = Color.black
    
    @Published public var secondView = false
    
    @Published public var showingSecondView = false
    
    @Published public var nextView = true
    
    @Published var color2: UIColor = UIColor.black
    @Published var color1: UIColor = UIColor.white
    
    @Published var viewss:Int = 0

    }
    
  

struct ContentView: View {
    
    @EnvironmentObject var colorss : Colors
    
    @State public var isActive : Bool = false
    
    @State var toggle1 = false;

    


    var body: some View {
        
       
        
        let outsideCircle = ZStack {
            Circle().fill(colorss.FgColor).frame(width: 97.0, height: 97.0)
            
            Circle().fill(colorss.BgColor).frame(width: 90.0, height: 90.0)
            
        }
        
        NavigationView() {
            if !colorss.nextView {
           
            ZStack {
                self.colorss.BgColor.ignoresSafeArea()
        VStack(spacing: 30.0) {
            Spacer()
            
            
            Text("Seeing Reality")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(colorss.FgColor)
            
            Spacer()
            
            
            HStack(spacing: 30.0){
                

                
                NavigationLink(destination: CameraView(currlZooom: Zoomlevel())) {
                    ZStack{
                        
                       
                    outsideCircle
                        
                    Image(systemName: "camera")
                    
                    .resizable()
                    .frame(width: 50.0, height: 41.0)
                        .fixedSize()
                        .foregroundColor(colorss.FgColor)
                    }
                }
                
                NavigationLink(destination: TextDetection()){
                ZStack{
                    
                   
                outsideCircle
                    
                Image(systemName: "character.book.closed")
                
                .resizable()
                    .frame(width: 46.0, height: 50.0)
                    .fixedSize()
                    .foregroundColor(colorss.FgColor)
                }
                    
                }
                
                
                NavigationLink(destination: Navigation()){
                ZStack{
                    
                   
                outsideCircle
                    
                Image(systemName: "mappin.and.ellipse")
                
                .resizable()
                    .frame(width: 43.0, height: 45.0)
                    .fixedSize()
                    .foregroundColor(colorss.FgColor)
                }
            }
               
                
                }
            HStack(spacing: 30.0){
                

                
                

                NavigationLink(destination: SettingsView(rootIsActive: self.$isActive),
                               isActive: self.$isActive) {
                ZStack{
                    
                   
                outsideCircle
                    
                Image(systemName: "gearshape")
                
                .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .fixedSize()
                    .foregroundColor(colorss.FgColor)
                }}.isDetailLink(false).simultaneousGesture(TapGesture().onEnded{
                    colorss.viewss+=1
                })
                NavigationLink(destination: AboutUsView()) {
                ZStack{
                    
                   
                outsideCircle
                    
                Image(systemName: "person.2")
                
                .resizable()
                    .frame(width: 65.0, height: 44.0)
                    .fixedSize()
                    
                    .foregroundColor(colorss.FgColor)
                }
            
            }
            }
        
           
            
            Spacer()
            Spacer()
            Spacer()
           
            
            Spacer()
               
            
        }
             
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        } else {
            Alternate_View()
        }

        }
        .background(colorss.BgColor)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        
        
        
    }

    }



struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
       
        if ContentView().toggle1 == false {
        ContentView()
        }	 else {
        Alternate_View()
        }
    }
}

struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    var tintColor: UIColor?
    
    init( backgroundColor: UIColor?, tintColor: UIColor?) {
       
       
        
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor
        UITableView.appearance().backgroundColor = backgroundColor
        
        let locationManager = CLLocationManager()
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
 
    func navigationBarColor(_ backgroundColor: UIColor?, _ tintColor: UIColor) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, tintColor: tintColor))
    }

}

