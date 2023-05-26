//
//  CGImage+Extension.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import VideoToolbox
import CoreGraphics

extension CGImage {
    static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let pixelBuffer = cvPixelBuffer else {
            return nil
        }
        
        var image: CGImage?
        VTCreateCGImageFromCVPixelBuffer(
            pixelBuffer,
            options: nil,
            imageOut: &image)
        return image
    }
}
