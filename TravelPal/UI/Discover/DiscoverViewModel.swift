//
//  DiscoverViewModel.swift
//  TravelPal
//
//  Created by Alexia Aldea on 02.09.2024.
//

import Combine
import UIKit
import CoreML
import Vision

enum ImageRecognitionCompletion {
    case completed(String)
    case error
}

class DiscoverViewModel: BaseViewModel {
    @Published var image: UIImage?
    let imageRecognitionCompletion = PassthroughSubject<ImageRecognitionCompletion, Never>()
    
    func convertUIImageToCIImage(_ image: UIImage) -> CIImage? {
        if let ciImage = image.ciImage {
            return ciImage
        }
        
        if let cgImage = image.cgImage {
            return CIImage(cgImage: cgImage)
        }
        
        return nil
    }

    func recognizeMonument(ciImage: CIImage) {
        let ceva = MobileNetV2().model
        guard let model = try? VNCoreMLModel(for: ceva) else {
            print("Failed to load model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation] {
                if let topResult = results.first {
                    DispatchQueue.main.async {
                        self.imageRecognitionCompletion.send(.completed(topResult.identifier))
                    }
                }
            } else {
                print("Failed to classify the image.")
                self.imageRecognitionCompletion.send(.error)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform image request: \(error.localizedDescription)")
                self.imageRecognitionCompletion.send(.error)
            }
        }
    }
}
