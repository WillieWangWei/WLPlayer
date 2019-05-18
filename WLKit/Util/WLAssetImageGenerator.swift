//
//  WLAssetImageGenerator.swift
//  WLPlayer
//
//  Created by 王炜 on 2019/5/17.
//  Copyright © 2019 Willie. All rights reserved.
//

import AVFoundation

struct WLAssetImageGenerator {
    
    private var generator: AVAssetImageGenerator
    private var queue: OperationQueue

    init(with asset: AVAsset) {
        generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
    }
    
    func asyncGenerateImages(at times: [NSValue],
                             appendReverse: Bool,
                             completion: @escaping (_ images: [UIImage])->()) {
        cancel()
        var images: [UIImage] = [UIImage]()
        var count = times.count
        
        generator.generateCGImagesAsynchronously(forTimes: times) { (_, cgImage, _, result, error) in
            
            if error != nil || result == .failed {
                count -= 1
                
            } else if result == .succeeded {
                let image = UIImage(cgImage: cgImage!)
                images.append(image)
            }
            
            if images.count == count {
                
                if appendReverse {
                    images += images.reversed()
                }
                
                completion(images)
            }
        }
    }
    
    func cancel() {
        generator.cancelAllCGImageGeneration()
    }
}
