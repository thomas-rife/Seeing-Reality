//
//  AboutUsView.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 4/5/21.
//

import SwiftUI

struct AboutUsView: View {
    @EnvironmentObject var colorss : Colors
    
    var text = "Our group consists of August Wetterau and Thomas Rife. One of our close friends was born with a visual impairment that couldn't be improved with any product that he tried on the market today. Every day, he has faced the challenge of not being able to see something because it was too far away given the condition that he had . That's when we decided to take matters into our own hands. Together, we designed an app and a headset to help the visually impaired. After numerous prototypes, we eventually made the right one for us, providing all the functionality and features we wanted. We hope to get our device into as many hands as possible and help to enable vision for everyone."
    
    var body: some View {
        let outsideCircle = ZStack {
            Circle().fill(colorss.FgColor).frame(width: 97.0, height: 97.0)
            
            Circle().fill(colorss.BgColor).frame(width: 90.0, height: 90.0)
            
        }
        
        ZStack() {
            colorss.BgColor.ignoresSafeArea()
            VStack {
                Spacer(minLength: 30)

                Spacer()
                
                Text(text).font(.body).multilineTextAlignment(.center).padding()
                
               
                Spacer(minLength: 160)
            }
        }.navigationTitle("About us").font(.largeTitle)
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
