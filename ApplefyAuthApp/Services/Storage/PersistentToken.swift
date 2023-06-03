//
//  PersistentToken.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import Foundation

/// A `PersistentToken` represents a `Token` stored in the `Keychain`. The keychain assigns each
/// saved `token` a unique `identifier` which can be used to recover the token from the keychain at
/// a later time.
public struct PersistentToken: Equatable, Hashable {
    
    /// A `Token` stored in the keychain.
    public let token: Token
    /// The keychain's persistent identifier for the saved token.
    public let identifier: Data

    /// Initializes a new `PersistentToken` with the given properties.
    internal init(token: Token, identifier: Data) {
        self.token = token
        self.identifier = identifier
    }

    /// Hashes the persistent token's identifier into the given hasher, providing `Hashable` conformance.
    public func hash(into hasher: inout Hasher) {
        // Since we expect every `PersistentToken`s identifier to be unique, the identifier's hash
        // value makes a simple and adequate hash value for the struct as a whole.
        hasher.combine(identifier)
    }
}
