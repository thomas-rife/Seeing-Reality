//
//  ScanDocumentView.swift
//  SwiftUI Seeing Reality
//
//  Created by August Wetterau on 1/21/21.
//

import SwiftUI
import VisionKit
import Vision

struct ScanDocumentView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText: String
    
    func makeCoordinator() -> Coordinator {
      Coordinator(recognizedText: $recognizedText, parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Nothing goes here
    }
    
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    
        var recognizedText: Binding<String>
        var parent: ScanDocumentView
        
        init(recognizedText: Binding<String>, parent: ScanDocumentView) {
            self.recognizedText = recognizedText
            self.parent = parent
        }
    
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            
            // do the processing of the scan
            let extractedImages = extractImages(from: scan)
            let processedText = recognizeText(from: extractedImages)
            recognizedText.wrappedValue = processedText
            
            parent.presentationMode.wrappedValue.dismiss()
            
        }
        
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages = [CGImage]()
            
            for index in 0..<scan.pageCount {
                let extractedImage = scan.imageOfPage(at:index)
                guard  let cgImage = extractedImage.cgImage else {continue}
                
                extractedImages.append(cgImage)
            }
            return extractedImages
        }
        
        fileprivate func recognizeText(from images: [CGImage]) -> String {
            var entireRecognizedText = ""
            
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else {return}
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return }
                
                let maximumRecognitionCandidates = 1
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                    
                    entireRecognizedText += "\(candidate.string)\n"
                    
            }
        }
            recognizeTextRequest.recognitionLevel = .accurate
            
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
            return entireRecognizedText
        }
    }
    
    }
    
    

