//
//  ScanViewModelTests.swift
//  ApplefyAuthAppTests
//
//  Created by Denys on 05.06.2023.
//

import XCTest
@testable import ApplefyAuthApp

class ScanTokenViewModelTests: XCTestCase {
    
    private var viewModel: ScanTokenViewModel!
    private var mockStore: MockTokenStore!
    private let addedTokenExpectation = XCTestExpectation(description: "added token expectation")
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockStore = MockTokenStore(addedTokenExpectation: addedTokenExpectation)
        viewModel = ScanTokenViewModel(tokenStore: mockStore)
    }
    
    override func tearDown() {
        viewModel = nil
        mockStore = nil
        super.tearDown()
    }
    
    @MainActor
    func testHandleDecodedText_WithValidURL_AddsToken() throws {
        // Arrange
        let validURL = "otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example"
        let url = URL(string: validURL)
        XCTAssertNotNil(url)
        let token = try Token(url: url!)
        viewModel.isScanning = true
        
        // Act
        viewModel.handleDecodedText(validURL)
        
        // Assert
        wait(for: [addedTokenExpectation], timeout: 2.0)
        XCTAssertEqual(viewModel.scannedToken, token)
        XCTAssertTrue(viewModel.tokenFound)
        XCTAssertTrue(viewModel.isScanning)
        XCTAssertNil(viewModel.error)
    }
    
    @MainActor
    func testHandleDecodedText_WithInvalidURL_ShowsErrorMessage() {
        // Arrange
        let invalidURL = "invalid-url"
        viewModel.isScanning = true
        
        // Act
        viewModel.handleDecodedText(invalidURL)
        
        // Assert
        XCTAssertNil(viewModel.scannedToken)
        XCTAssertFalse(viewModel.tokenFound)
        XCTAssertTrue(viewModel.isScanning)
    }
    
    @MainActor
    func testDetectQRCode_WithValidQRCode_ReturnsDecodedText() {
        // Arrange
        let qrCodeImage = UIImage.demoScannerImage()
        XCTAssertNotNil(qrCodeImage)
        
        // Act
        let decodedText = viewModel.detectQRCode(qrCodeImage!)
        
        // Assert
        XCTAssertEqual(decodedText, "otpauth://totp/Cybersecurity%20Code?secret=testSecret&issuer=lviv%20polytechnic")
    }
    
    @MainActor
    func testDetectQRCode_WithInvalidQRCode_ReturnsNil() {
        // Arrange
        let invalidQRCodeImage = UIImage.demoWrongImage()
        XCTAssertNotNil(invalidQRCodeImage)
        
        // Act
        let decodedText = viewModel.detectQRCode(invalidQRCodeImage!)
        
        // Assert
        XCTAssertNil(decodedText)
    }
}
