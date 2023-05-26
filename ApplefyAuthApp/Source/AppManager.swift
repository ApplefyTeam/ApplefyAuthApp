//
//  AppManager.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import Foundation

class AppManager {
    
    static let shared = AppManager()
    public let store: TokenStore
    public let cameraManager: CameraManager
    public let frameManager: FrameManager
    
    private init() {
        do {
            store = try KeychainTokenStore(
                keychain: Keychain.sharedInstance,
                userDefaults: UserDefaults.standard
            )
        } catch {
            // If the TokenStore could not be created, the app is unusable.
            fatalError("Failed to load token store: \(error)")
        }
        cameraManager = CameraManager.shared
        frameManager = FrameManager.shared
    }
    
}
