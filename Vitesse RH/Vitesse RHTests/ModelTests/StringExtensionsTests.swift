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

    func testPhoneInvalid() {
        // Given
        let phone1 = "06000000000"
        let phone2 = "06 00 00 00 0"
        let phone3 = "+3360000000"
        let phone4 = "+33 06 00 00 00 00"
        let phone5 = "1600000000"
        let phone6 = "16 00 00 00 00"
        // When
        let result1 = phone1.isValidFrPhone()
        let result2 = phone2.isValidFrPhone()
        let result3 = phone3.isValidFrPhone()
        let result4 = phone4.isValidFrPhone()
        let result5 = phone5.isValidFrPhone()
        let result6 = phone6.isValidFrPhone()
        // Then
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
        XCTAssertFalse(result3)
        XCTAssertFalse(result4)
        XCTAssertFalse(result5)
        XCTAssertFalse(result6)
    }

    func testPhoneValid() {
        // Given
        let phone1 = "0600000000"
        let phone2 = "06 00 00 00 00"
        // When
        let result1 = phone1.isValidFrPhone()
        let result2 = phone2.isValidFrPhone()
        // Then
        XCTAssertTrue(result1)
        XCTAssertTrue(result2)
    }

    func testFrPhonePatternValid() {
        // Given
        var phone1 = "0600000000"
        // When
        let phone2 = phone1.getFrPhonePattern()
        phone1.applyFrPhonePattern()
        // Then
        XCTAssertEqual("06 00 00 00 00", phone1)
        XCTAssertEqual("06 00 00 00 00", phone2)
    }

    func testFrPhonePatternToLong() {
        // Given
        var phone1 = "06000000001"
        // When
        let phone2 = phone1.getFrPhonePattern()
        phone1.applyFrPhonePattern()
        // Then
        XCTAssertEqual("06 00 00 00 00", phone1)
        XCTAssertEqual("06 00 00 00 00", phone2)
    }

    func testFrPhonePatternToShort() {
        // Given
        var phone1 = "060000000"
        // When
        let phone2 = phone1.getFrPhonePattern()
        phone1.applyFrPhonePattern()
        // Then
        XCTAssertEqual("06 00 00 00 0", phone1)
        XCTAssertEqual("06 00 00 00 0", phone2)
    }
}
