//
//  AppErrorTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class AppErrorTests: XCTestCase {

    func testAppErrorMessage() {
        XCTAssertEqual(AppError.serverErr.message, "Please restart the application.\nError: 101, launch server")
        XCTAssertEqual(AppError.invalidUrl.message, "Please restart the application.\nError: 102")
        XCTAssertEqual(AppError.badStatusCode.message, "Please restart the application.\nError: 103")
        XCTAssertEqual(AppError.invalidData.message, "Please restart the application.\nError: 104")
        XCTAssertEqual(AppError.invalidJson.message, "Please restart the application.\nError: 105")
        XCTAssertEqual(AppError.invalidMail.message, "Email is invalid! Change your email and try again.")
        XCTAssertEqual(AppError.linkedInUrlEmpty.message, "LinkedIn url is empty! Add the url and try again.")
        XCTAssertEqual(AppError.invalidLinkedInUrl.message, "LinkedIn url is invalid! Change the url and try again.")
        XCTAssertEqual(AppError.unknown.message, "Please restart the application.\nError: 100")
    }
}
