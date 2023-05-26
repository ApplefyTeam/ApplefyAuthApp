//
//  AddNewTokenViewModel.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import AVFoundation
import CoreImage
import Combine

class ScanTokenViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    @Published var error: Error?
    @Published var scannedToken: Token? = nil
    @Published var isScanning: Bool = false
    @Published var tokenFound: Bool = false
    
    let appManager = AppManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        appManager.frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
        
        appManager.cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
    }
    
    // MARK: QRScannerDelegate
    
    private var lastScanTime = Date(timeIntervalSince1970: 0)
    private let minimumScanInterval: TimeInterval = 1
    
    func handleDecodedText(_ text: String) {
        guard isScanning else {
            return
        }
        
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
            scannedToken = token
            tokenFound = true
        }
    }
}
