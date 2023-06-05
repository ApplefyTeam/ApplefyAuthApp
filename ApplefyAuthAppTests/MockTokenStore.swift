//
//  MockTokenStore.swift
//  ApplefyAuthAppTests
//
//  Created by Denys on 05.06.2023.
//

import Foundation

import XCTest
@testable import ApplefyAuthApp


// Mock implementation of TokenStore for testing purposes
class MockTokenStore: TokenStoreProtocol {
    var reloadTokensExpectation: XCTestExpectation?
    var addedTokenExpectation: XCTestExpectation?
    private(set) var persistentTokens: [PersistentToken] = []
    
    init(reloadTokensExpectation: XCTestExpectation? = nil, addedTokenExpectation: XCTestExpectation? = nil) {
        self.addedTokenExpectation = addedTokenExpectation
        self.reloadTokensExpectation = reloadTokensExpectation
        
        self.persistentTokens = DemoTokenStore().persistentTokens
    }
    
    func loadTokens() throws {
        reloadTokensExpectation?.fulfill()
    }

    func deletePersistentToken(_ persistentToken: PersistentToken) throws {
        persistentTokens = persistentTokens.filter({ $0.token != persistentToken.token })
    }
    
    func addToken(_ token: Token) throws {
        addedTokenExpectation?.fulfill()
    }
}
