//
//  AddNewTokenViewModel.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import AVFoundation
import CoreImage
import Combine
import UIKit

class ScanTokenViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    @Published var error: Error?
    @Published var scannedToken: Token? = nil
    @Published var isScanning: Bool = false
    @Published var tokenFound: Bool = false
    
    private let appManager = AppManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        appManager.frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                let image = CGImage.create(from: buffer)
                return image
            }
            .assign(to: &$frame)
        
        appManager.cameraManager.$error
            .receive(on: RunLoop.main)
            .map { [weak self] error in
                if let self, let _ = error {
                    if let image = UIImage.demoScannerImage() {
                        self.frame = image.cgImage
                        if let text = self.detectQRCode(image) {
                            handleDecodedText(text)
                        }
                    }
                }
                return error
            }
            .assign(to: &$error)
    }
    
    // MARK: QRScannerDelegate
    
    private var lastScanTime = Date(timeIntervalSince1970: 0)
    private let minimumScanInterval: TimeInterval = 1
    
    func handleDecodedText(_ text: String) {
        guard isScanning else {
            return
        }
        print("handleDecodedText \(text)")
        let now = Date()
        if now.timeIntervalSince(lastScanTime) > minimumScanInterval {
            lastScanTime = now
            guard let url = URL(string: text),
                  let token = try? Token(url: url) else {
                // Show an error message
                tokenFound = false
                scannedToken = nil
                return
            }
            do {
                try appManager.store.addToken(token)
                scannedToken = token
                tokenFound = true
                print("handleDecodedText success \(token.name)")
                return
            } catch {
                scannedToken = token
                tokenFound = true
                return
            }
        }
    }
    
    func detectQRCode(_ image: UIImage) -> String? {
        var result: String? = nil
        if let ciImage = CIImage.init(image: image) {
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            if let features = qrDetector?.features(in: ciImage, options: options) {
                for case let row as CIQRCodeFeature in features {
                    result = row.messageString
                }
            }
            return result
        } else {
            return result
        }
    }
}
