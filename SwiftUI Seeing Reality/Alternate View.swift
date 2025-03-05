//
//  Alternate View.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/19/21.
//

import SwiftUI

struct Alternate_View: View {
    @EnvironmentObject var colorss : Colors
    
    @State public var isActive : Bool = false
    
    var body: some View {
        let outsideCircle = ZStack {
            Circle().fill(colorss.FgColor).frame(width: 77.0, height: 77.0)
            
                                Circle().fill(colorss.BgColor).frame(width: 70.0, height: 70.0)}
        
            
            ZStack {
                colorss.BgColor.ignoresSafeArea()
            VStack(alignment: .center, spacing: 30.0) {
      
            Spacer()
                .frame(height: 26.0)
            Text("Seeing Reality")
                
                .font(.largeTitle)
                
                .fontWeight(.heavy)
                .foregroundColor(colorss.FgColor)
                
                
            
            
                
            
            HStack(spacing: 30.0) {
               
               
                    
                
                VStack(alignment: .leading, spacing: 40.0){
                
                
                
                    NavigationLink(destination: CameraView(currlZooom: Zoomlevel())) {
                    HStack() {
                        
                    ZStack{
          
                    outsideCircle
                        
                    Image(systemName: "camera")
                    
                    .resizable()
                    .frame(width: 45.0, height: 36.0)
                        .fixedSize()
                        .foregroundColor(colorss.FgColor)
                        
                    }
                        Text("Zoom Camera")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorss.FgColor)
                    }
                }
                    NavigationLink(destination: TextDetection()){
                    HStack() {
                       
                        ZStack{
                            
                           
                        outsideCircle
                            
                        Image(systemName: "character.book.closed")
                        
                        .resizable()
                            .frame(width: 46.0, height: 50.0)
                            .fixedSize()
                            .foregroundColor(colorss.FgColor)
                        }
                            
                        }
                        Text("Text to Speech")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorss.FgColor)
                    }
                    NavigationLink(destination: Navigation()){
                    HStack() {
            
                        ZStack{
                            
                           
                        outsideCircle
                            
                        Image(systemName: "mappin.and.ellipse")
                        
                        .resizable()
                            .frame(width: 43.0, height: 45.0)
                            .fixedSize()
                            .foregroundColor(colorss.FgColor)
                        }
                    }
                        Text("Navigation")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorss.FgColor)
                    }

                        NavigationLink(destination: SettingsView(rootIsActive: self.$isActive), isActive: self.$isActive) {
                            Button(action: {colorss.showingSecondView.toggle()}) {
                                
                     
                                NavigationLink(destination: SettingsView(rootIsActive: self.$isActive), isActive: self.$isActive) {
                    HStack() {
                        
                        ZStack{
                            
                           
                        outsideCircle
                            
                        Image(systemName: "gearshape")
                        
                        .resizable()
                            .frame(width: 50.0, height: 50.0)
                            .fixedSize()
                            .foregroundColor(colorss.FgColor)
                        }
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorss.FgColor)
                    }
                  }
                }
                        }
                    NavigationLink(destination: AboutUsView()) {
                ZStack{
                    
                   
                outsideCircle
                    
                Image(systemName: "person.2")
                
                .resizable()
                    .frame(width: 55.0, height: 34.0)
                    .fixedSize()
                    .foregroundColor(colorss.FgColor)
                }
                        Text("About Us")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorss.FgColor)
                    }
            
            }
                
                Spacer()
                    
       
                
            }
            .padding()
            
                
                
                    
                
            Spacer()
                .frame(height: 95.658)
            
               
                
        }
                
            }.background(colorss.BgColor).ignoresSafeArea(.all)
            
       
     
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
        
    
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
}

struct Alternate_View_Previews: PreviewProvider {
    static var previews: some View {
       Alternate_View()
    }
}
