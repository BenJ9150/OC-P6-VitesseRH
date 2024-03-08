//
//  StringExtensionsTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class StringExtensionsTests: XCTestCase {

    // MARK: Email

    func testEmailInvalid() {
        // Given
        let mail1 = "test"
        let mail2 = "test@com"
        let mail3 = "test.com"
        let mail4 = "test.mail@com"
        // When
        let result1 = mail1.isValidEmail()
        let result2 = mail2.isValidEmail()
        let result3 = mail3.isValidEmail()
        let result4 = mail4.isValidEmail()
        // Then
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
        XCTAssertFalse(result3)
        XCTAssertFalse(result4)
    }

    func testEmailValid() {
        // Given
        let mail = "test@gmail.com"
        // When
        let result = mail.isValidEmail()
        // Then
        XCTAssertTrue(result)
    }

    // MARK: Phone

    func testPhoneInValid() {
        // Given
        let phone1 = "06000000000"
        let phone2 = "06 00 00 00 0"
        let phone3 = "+3360000000"
        let phone4 = "+33 06 00 00 00 00"
        // When
        let result1 = phone1.isValidPhone()
        let result2 = phone2.isValidPhone()
        let result3 = phone3.isValidPhone()
        let result4 = phone4.isValidPhone()
        // Then
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
        XCTAssertFalse(result3)
        XCTAssertFalse(result4)
    }

    func testPhoneValid() {
        // Given
        let phone1 = "0600000000"
        let phone2 = "06 00 00 00 00"
        let phone3 = "+33600000000"
        let phone4 = "+33 6 00 00 00 00"
        // When
        let result1 = phone1.isValidPhone()
        let result2 = phone2.isValidPhone()
        let result3 = phone3.isValidPhone()
        let result4 = phone4.isValidPhone()
        // Then
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
        XCTAssertTrue(result3)
        XCTAssertTrue(result4)
    }
}
