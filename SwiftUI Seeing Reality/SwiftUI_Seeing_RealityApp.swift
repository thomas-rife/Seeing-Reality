//
//  SwiftUI_Seeing_RealityApp.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/18/21.
//

import SwiftUI

@main
struct SwiftUI_Seeing_RealityApp: App {
    @State static var toggle = false;
    @State private var colorss = Colors()
    @State private var currlZooom = Zoomlevel()
    
    var body: some Scene {
       WindowGroup {
            if SwiftUI_Seeing_RealityApp.toggle == false {
                ContentView().environmentObject(colorss).environmentObject(Constants()).environmentObject(Colors())
                
            } else {
                Alternate_View().environmentObject(colorss).environmentObject(Constants()).environmentObject(Colors())
            }
        }
    }
}
