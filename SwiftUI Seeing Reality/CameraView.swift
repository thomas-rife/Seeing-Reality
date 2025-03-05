//
//  CameraView.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/18/21.
//

import SwiftUI
import AVFoundation

class Zoomlevel : ObservableObject  {
    @Published public var CurrentZoom = Zoom.currZoom
    
    
}

struct CameraView: View {
    
    @StateObject var camera = CameraModel()
    
    @State var isDragging = false
    
    @StateObject var currlZooom : Zoomlevel


    
    

    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }
    
    var body: some View {
        
        ZStack() {
            
            
        CameraPreview(camera: camera)
            .ignoresSafeArea(.all, edges: .all)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            if value.translation.height < 0 {
                                // up
                                Zoom().zoomIn(0.05)
                            }

                            if value.translation.height > 0 {
                                // down
                                Zoom().zoomOut(0.05)
                            }
                        }))
                            

        }.onAppear(perform: {
            camera.Check()
        })
        .navigationBarBackButtonHidden(false)
  
    }
}

struct CameraView_Previews: PreviewProvider {
    static let currlZoom = Zoomlevel()
    static var previews: some View {
        CameraView(currlZooom: Zoomlevel())
    }
}


class CameraModel: ObservableObject {
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview : AVCaptureVideoPreviewLayer!
    
    
    
    
    public func Check() {
        //checking camera perms
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Setting up
            setUp()
            return
        case .notDetermined:
            // Asking for Permission
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
                
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    func setUp() {
        // Setting up camera
        do {
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(for: .video)
            
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    
    
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        // Your own properties...
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        // Starting session
        camera.session.startRunning()
        
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

class Zoom: NSObject, ObservableObject {
    
    
    @EnvironmentObject var currlZooom : Zoomlevel
    
    
    
   public var maxZoomFactor: CGFloat = 10.0
    
    
    func zoom(_ zoomFac: Float) {
        let device = AVCaptureDevice.default(for: .video)
            do {
                try device!.lockForConfiguration()
                device!.ramp(toVideoZoomFactor: CGFloat(zoomFac), withRate: 3.0)
                device!.unlockForConfiguration()
                
            }
            catch {
                print(error.localizedDescription)
            }
    }
    
 
    
    var zoomFactor: CGFloat = 1.0 {
        didSet {
            if self.zoomFactor < 1.0 || self.zoomFactor > self.maxZoomFactor { return }
            if let device = AVCaptureDevice.default(for: .video) {
                do {
                    try device.lockForConfiguration()
                    device.ramp(toVideoZoomFactor: self.zoomFactor, withRate: 3.0)
                    device.unlockForConfiguration()
                   
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    public static var currZoom: Float = 1.0
    func zoomIn(_ amount: Float) {
            
        if (Zoom.currZoom + amount) < Float(self.maxZoomFactor) {
                let zoomin: Float = Zoom.currZoom + amount
                zoom(zoomin)
                Zoom.currZoom = zoomin
   
                print(Zoom.currZoom)
                
            
            
            }

        
}
    @Published var currentZoom:Float = currZoom
    func zoomOut(_ amount: Float) {
        
            if (Zoom.currZoom - amount) > 1.0 {
            let zoomout: Float = Zoom.currZoom - amount
            zoom(zoomout)
            Zoom.currZoom = zoomout
            
            print(Zoom.currZoom)
        }
    }
    
}

