//
//  KeychainManagerTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class KeychainManagerTests: XCTestCase {

    override class func tearDown() {
        // delete token for new test
        KeychainManager.deleteTokenInKeychain()
        print("token deleted for test")
        print(KeychainManager.token)
    }

    // MARK: Update token

    func testUpdateTokenSuccess() {
        // Given
        KeychainManager.token = "TokenToUpdate"
        // When
        KeychainManager.token = MockData.authCorrectToken
        // Then
        XCTAssertEqual(KeychainManager.token, MockData.authCorrectToken)
    }

    // MARK: Delete token

    func testDeleteTokenSuccess() {
        // Given
        KeychainManager.token = MockData.authCorrectToken
        // When
        KeychainManager.deleteTokenInKeychain()
        // Then
        XCTAssertEqual(KeychainManager.token, "")
    }
}
