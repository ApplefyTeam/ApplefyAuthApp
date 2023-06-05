//
//  ListOfTokensViewModelTests.swift
//  ApplefyAuthAppTests
//
//  Created by Denys on 05.06.2023.
//

import Foundation

import XCTest
@testable import ApplefyAuthApp

class ListOfTokensViewModelTests: XCTestCase {

    private var viewModel: ListOfTokensViewModel!
    private var mockStore: MockTokenStore!
    private let reloadExpectation = XCTestExpectation(description: "reload expectation")

    override func setUp() {
        super.setUp()
        mockStore = MockTokenStore(reloadTokensExpectation: reloadExpectation)
        viewModel = ListOfTokensViewModel(tokenStore: mockStore)
    }

    override func tearDown() {
        viewModel = nil
        mockStore = nil
        super.tearDown()
    }

    func testRefresh() {
        // Given
        viewModel.tokens = []

        // When
        XCTAssertFalse(viewModel.isLoading)
        Task {
            try await viewModel.refresh()
        }

        // Then
        wait(for: [reloadExpectation], timeout: 2.0)
        XCTAssertFalse(viewModel.tokens.isEmpty)
    }

    func testDeleteItem() {
        let indexSetToDelete = IndexSet(integer: 1)
        // Given
        let demo = DemoTokenStore()
        var tokens = demo.persistentTokens
        viewModel.tokens = tokens
        tokens.remove(atOffsets: indexSetToDelete)
        let expectedTokensAfterDeletion = tokens

        // When
        viewModel.deleteItem(at: indexSetToDelete)

        // Then
        wait(for: [reloadExpectation], timeout: 2.0)
        print(viewModel.tokens.count)
        print(expectedTokensAfterDeletion.count)
        XCTAssertEqual(viewModel.tokens.count, expectedTokensAfterDeletion.count)
    }
}

