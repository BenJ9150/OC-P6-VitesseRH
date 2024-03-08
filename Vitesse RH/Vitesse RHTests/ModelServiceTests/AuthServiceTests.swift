//
//  AuthServiceTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class AuthServiceTests: XCTestCase {

    var authService: AuthService!
    var expectation: XCTestExpectation!

    // MARK: setUp and tearDown

    override func setUp() {
        // Create URL Session configuration
        let configuration = URLSessionConfiguration.default

        // Providing an array of protocol classes to the configuration
        // so when the request gets fired, system will create an instance of registered protocol classes
        // and call “canInit” method on them to see if the class handles the current request.
        // If yes, it will give responsibility to the class to complete the network operation.
        configuration.protocolClasses = [MockURLProtocol.self]

        // Create url session with this configuration
        let urlSession = URLSession.init(configuration: configuration)

        // Instantiate AuthService with this url session
        authService = AuthService(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    override class func tearDown() {
        // delete token for new test
        KeychainManager.deleteTokenInKeychain()
        print("token deleted for test")
        print(KeychainManager.token)
    }

    // MARK: - SignIn UrlSession Error

    func testSignInUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await authService.signIn(withEmail: "test", andPwd: "test") {
            case .success:
                XCTFail("error in SignIn UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: SignIn Invalid Data

    func testSignInInvalidData() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.incorrectData)
        }
        // When
        Task {
            switch await authService.signIn(withEmail: "test", andPwd: "test") {
            case .success:
                XCTFail("error in SignIn Invalid Data")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidJson)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: SignIn Success

    func testSignInSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.authCorrectData)
        }
        // When
        Task {
            switch await authService.signIn(withEmail: "test", andPwd: "test") {
            case .success(let isAdmin):
                // then
                XCTAssertTrue(isAdmin)
                XCTAssertEqual(KeychainManager.token, MockData.authCorrectToken)

            case .failure:
                XCTFail("error in SignIn Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Register UrlSession Error

    func testRegisterUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await authService.register(mail: "test", password: "test", firstName: "test", lastName: "test") {
            case .success:
                XCTFail("error in Register UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: Register Success

    func testRegisterSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusCreated, data: MockData.emptyData)
        }
        // When
        Task {
            switch await authService.register(mail: "test", password: "test", firstName: "test", lastName: "test") {
            case .success(let result):
                // then
                XCTAssertTrue(result)

            case .failure:
                XCTFail("error in Register Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
