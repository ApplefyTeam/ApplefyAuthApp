//
//  AddNewTokenViewModel.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import AVFoundation
import CoreImage
import Combine
#if os(macOS)
import AppKit
import Cocoa
#else
import UIKit
#endif

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
            .compactMap { [weak self] buffer in
                let cgImage = CGImage.create(from: buffer)
                if let self, self.isScanning, let cgImage {
                    #if os(macOS)
                    let uiImage = UIImage(cgImage: cgImage, size: NSSize(width: 1000, height: 1000))
                    #else
                    let uiImage = UIImage(cgImage: cgImage)
                    #endif
                    if let text = self.detectQRCode(uiImage) {
                        self.handleDecodedText(text)
                    }
                }
                return cgImage
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
        isScanning = false
        print("handleDecodedText \(text)")
        let now = Date()
        if now.timeIntervalSince(lastScanTime) > minimumScanInterval {
            lastScanTime = now
            guard let url = URL(string: text),
                  let token = try? Token(url: url) else {
                // Show an error message
                tokenFound = false
                scannedToken = nil
                isScanning = true
                return
            }
            do {
                try appManager.store.addToken(token)
                scannedToken = token
                tokenFound = true
                isScanning = true
                print("handleDecodedText success \(token.name)")
                return
            } catch {
                scannedToken = nil
                tokenFound = false
                print("handleDecodedText error \(error)")
                isScanning = true
                return
            }
        }
    }
    
    func detectQRCode(_ image: UIImage) -> String? {
        #if os(macOS)
        return nil
        #else
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
        #endif
    }
}
