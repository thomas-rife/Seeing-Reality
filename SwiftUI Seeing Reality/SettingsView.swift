//
//  SettingsView.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 2/2/21.
//

import SwiftUI
import Combine
import UIKit


struct SettingsView: View{
    @EnvironmentObject var colorss : Colors
   
    @State private var isToggle : Bool = false
    
    @State var blueLightFilter = false
    @State var showStatusBar = false
    
    @State var light = false
    @State var dark = false
    @State var system = true
    
    @Binding var rootIsActive : Bool
   
    
   
    
    

    
    
    @Environment(\.presentationMode) var presentationMode
    
    
    
    
        var view = ContentView()
    
    
  
        var body: some View {
            let outsideCircle = ZStack {
                Circle().fill(Color.white).frame(width: 37.0, height: 37.0)
                
                Circle().fill(Color.green).frame(width: 30.0, height: 30.0)
                
            }
            
            ZStack {
               
            colorss.BgColor.ignoresSafeArea()

        
                VStack() {
                    
                    
                    HStack() {
                       
                    Button(action: {
                    
                        if (colorss.secondView) {
                            UINavigationBar.setAnimationsEnabled(true)
                            self.rootIsActive = false
                        } else {
                            colorss.showingSecondView.toggle()
                        }
                        
                    }) {
                        HStack {
                            Image(systemName: "arrow.left.circle").foregroundColor(colorss.FgColor)
                            Text("Back").foregroundColor(colorss.FgColor)
                        }
                    }.padding(.horizontal, 10)
                        Spacer()
                        Spacer()
                    }
                    
                    HStack {
                        
                        Text("Settings").bold().font(.largeTitle).padding(.horizontal, 30).foregroundColor(colorss.FgColor)
                   
                        Spacer()
                    }
                    Spacer()
                   
                    Spacer()
                    HStack() {
                        
                        Text("Color Theme").bold().padding(.horizontal, 30).foregroundColor(colorss.FgColor)
                        Spacer()
                    }
                ZStack() {
                    
                    
   
                    
                HStack() {

                    NavigationLink(destination: SettingsView(rootIsActive: self.$rootIsActive)) {
                        ZStack() {
                            
                            if light {
                            Rectangle().frame(width: 105, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(27).foregroundColor(Color.white)
                            }
                            
                            Rectangle().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(25).foregroundColor(Color.gray)
                            
                            VStack() {
                                ZStack() {
                                Circle().fill(Color.black).frame(width: 37.0, height: 37.0)
                                
                                Circle().fill(Color.white).frame(width: 30.0, height: 30.0)
                                }
                                Text("Light").foregroundColor(colorss.FgColor)
                            }
                        }
                    
                    }.isDetailLink(false).simultaneousGesture(TapGesture().onEnded{
                        system = false
                           dark = false
                           light = true
                        colorss.BgColor = Color(red: 200 / 255,green: 200 / 255,blue: 200 / 255)
                        colorss.FgColor = Color.black
                        colorss.color2 = UIColor.black
                        colorss.color1 = UIColor.white
                        UINavigationBar.setAnimationsEnabled(false)
                       
                            
                    })
                    
                    
                    NavigationLink(destination: SettingsView(rootIsActive: self.$rootIsActive)) {
                        ZStack() {
                            if dark {
                            Rectangle().frame(width: 105, height: 105, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(27).foregroundColor(Color.white)
                        }
                            Rectangle().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).cornerRadius(25).foregroundColor(Color.gray)
                            
                            VStack() {
                                ZStack() {
                                Circle().fill(Color.white).frame(width: 37.0, height: 37.0)
                                
                                Circle().fill(Color.black).frame(width: 30.0, height: 30.0)
                                }
                                Text("Dark").foregroundColor(colorss.FgColor)
                            }
                        }
                    }.isDetailLink(false).simultaneousGesture(TapGesture().onEnded{
                        system = false
                        dark = true
                        light = false
                        colorss.BgColor = Color.black
                        colorss.FgColor = Color(red: 200 / 255,green: 200 / 255,blue: 200 / 255)
                        colorss.color2 = UIColor.white
                        colorss.color1 = UIColor.black
                        UINavigationBar.setAnimationsEnabled(false)
                    })
                 
                    
                    
                    }
                    }
              
                   
                   
                    List {
                        
                        
                        Section() {
                            Toggle(isOn: self.$colorss.nextView) {
                                                    Text("Swap UI")
                                                        .font(.title3)
                                                        .foregroundColor(colorss.FgColor)
                            }.simultaneousGesture(TapGesture().onEnded{
                                UINavigationBar.setAnimationsEnabled(true)
                            })
                            
                                                  
                        }      .listRowBackground(colorss.BgColor.opacity(0.7))
                        
                      
                      
                        
                        

                                            .listRowBackground(colorss.BgColor.opacity(0.7))
                        .listRowBackground(colorss.BgColor.opacity(0.7))
                            
                        
                        
                   
                    }.listStyle(GroupedListStyle())
                    
                    Spacer()
                }
                
            }
            .listItemTint(Color.red)
            
            .navigationBarHidden(true)
        
            .navigationBarColor(UIColor(colorss.BgColor), UIColor(colorss.FgColor))
            
            
        
      
            
            .fullScreenCover(isPresented: self.$colorss.showingSecondView, content: {
                Alternate_View().environmentObject(colorss)
            })
}
    }
struct SettingsView_Previews: PreviewProvider {
    static let colorss = Colors()
    static var previews: some View {
        
        
        SettingsView(rootIsActive: ContentView().$isActive).environmentObject(colorss)
    }
}






