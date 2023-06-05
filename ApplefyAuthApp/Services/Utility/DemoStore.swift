//
//  Demo.swift
//  ApplefyAuthApp
//
//  Created by Denys on 01.06.2023.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension CommandLine {
    static var isDemo: Bool {
#if targetEnvironment(simulator)
        return true
#elseif DEBUG
        return arguments.contains("--demo")
            || UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT")
#else
        return false
#endif
    }
}

class DemoTokenStore: TokenStoreProtocol {
    var persistentTokens: [PersistentToken] {
        demoTokens.map(PersistentToken.init(demoToken:))
    }

    private var demoTokens = [
        Token(
            name: "john.appleseed@gmail.com",
            issuer: "Google",
            factor: .timer(period: 10)
        ),
        Token(
            name: "johnappleseed",
            issuer: "GitHub",
            factor: .timer(period: 20)
        ),
        Token(
            issuer: "Dropbox",
            factor: .timer(period: 30)
        ),
        Token(
            name: "john@appleseed.com",
            factor: .counter(0)
        ),
        Token(
            name: "johnny.apple",
            issuer: "Facebook",
            factor: .timer(period: 40)
        ),
    ]

    private struct Error: Swift.Error {}
    
    func deletePersistentToken(_ persistentToken: PersistentToken) throws {
        demoTokens = demoTokens.filter({ $0.issuer != persistentToken.token.issuer }) // && $0.generator != token.token.generator })
    }
}

private extension Token {
    init(name: String = "", issuer: String = "", factor: Generator.Factor) {
        // swiftlint:disable:next force_try
        let generator = try! Generator(factor: factor, secret: Data(), algorithm: .sha1, digits: 6)
        self.init(name: name, issuer: issuer, generator: generator)
    }
}

#if DEBUG
//@testable import OneTimePassword

private extension PersistentToken {
    init(demoToken: Token) {
        // swiftlint:disable:next force_unwrapping
        let identifier = UUID().uuidString.data(using: String.Encoding.utf8)!

        self.init(token: demoToken, identifier: identifier)
    }
}

#endif

//extension TokenEntryForm {
//    static let demoForm: TokenEntryForm = {
//        // Construct a pre-filled demo form.
//        var form = TokenEntryForm()
//        _ = form.update(with: .issuer("Google"))
//        _ = form.update(with: .name("john.appleseed@gmail.com"))
//        _ = form.update(with: .secret("JBSWY3DPEHPK6PX9"))
//        if UIScreen.main.bounds.height > 550 {
//            // Expand the advanced options for iPhone 5 and later, but not for the earlier 3.5-inch screens.
//            _ = form.update(with: .showAdvancedOptions)
//        }
//        return form
//    }()
//}

extension DisplayTime {
    /// A constant demo display time, selected along with the time-based token periods to fix the progress ring at an
    /// aesthetically-pleasing angle.
    static let demoTime = DisplayTime(date: Date(timeIntervalSince1970: 123_456_783.75))
}

extension UIImage {
    static func demoScannerImage() -> UIImage? {
        return UIImage(named: "qr_code_example")
    }
    
    static func demoWrongImage() -> UIImage? {
        return UIImage(systemName: "apple.logo")
    }
}


extension TokenStoreProtocol {
    
    func addToken(_ token: ApplefyAuthApp.Token) throws {
        
    }
    
    func saveToken(_ token: ApplefyAuthApp.Token, toPersistentToken persistentToken: ApplefyAuthApp.PersistentToken) throws {
        
    }
    
    func updatePersistentToken(_ persistentToken: ApplefyAuthApp.PersistentToken) throws {
        
    }
    
    func moveTokenFromIndex(_ origin: Int, toIndex destination: Int) throws {
        
    }
    
    func loadTokens() throws {
        print("TokenStoreProtocol \(#function)")
    }
    
    func deletePersistentToken(_ token: PersistentToken) throws {
    }
}
