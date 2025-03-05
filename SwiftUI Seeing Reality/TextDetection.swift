//
//  TextDetection.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/20/21.
//

import SwiftUI
import Combine
import AVFoundation

struct TextDetection: View {
    @EnvironmentObject var colorss : Colors
    
    @State private var recognizedText = "Tap button to start scanning."
    
    @State private var showingScanningView = false
    
    
    
    func speak(_ text: String)  {
    let voice = AVSpeechSynthesisVoice(language: "en-US")
    
    let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = 0.5
    
    let synthesizer = AVSpeechSynthesizer()
        
        synthesizer.speak(utterance)
    }
    
    
    var body: some View {
        
            
                
                ZStack {
                    colorss.BgColor.ignoresSafeArea()
                VStack(alignment: .center) {
                    
                        
                    
                    Spacer()
                    Spacer()
                    
                        
                    ScrollView {
                        Button(action: {
                            speak(recognizedText)
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous) .fill(colorss.FgColor)
                                
                                Text(recognizedText)
                                    .padding()
                                    .foregroundColor(colorss.BgColor)
                            }
                            .padding()
                        }
                        
                    }
                    Spacer()
                    
                    HStack() {
                    
                        
                        Button(action: {
                            //Scan here
                            self.showingScanningView = true
                        }) {
                            Text("Start Scanning")
                        }
                        .padding()
                        .foregroundColor(colorss.BgColor)
                        .background(Capsule().fill(colorss.FgColor))
                    }
                    .padding()
                    Spacer()
                }
                
                
                
                    
                }
                
                .navigationBarTitle("Text Recognition", displayMode: .inline).foregroundColor(colorss.FgColor)
               
                .sheet(isPresented: $showingScanningView) {
                    ScanDocumentView(recognizedText: self.$recognizedText).ignoresSafeArea()
            }
                .navigationBarColor(UIColor(colorss.FgColor), UIColor(colorss.BgColor))
   
                
            
          
            
    
}
    
    
}




struct TextDetection_Previews : PreviewProvider {
    static var previews: some View {
        TextDetection()
    }
}

