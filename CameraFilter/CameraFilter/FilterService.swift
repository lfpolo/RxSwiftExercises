//
//  FilterService.swift
//  CameraFilter
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import Foundation
import CoreImage
import UIKit
import RxSwift

class FilterService {
    private var context = CIContext()
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            
            return Disposables.create()
        }
        
        
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        guard let filter = CIFilter(name: "CICMYKHalftone") else {
            return
        }
        
        filter.setValue(2.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let outputImage = filter.outputImage, let cgimg = self.context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
