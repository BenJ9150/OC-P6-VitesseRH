//
//  UrlSessionBuilderTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class UrlSessionBuilderTests: XCTestCase {

    var urlSessionBuilder: UrlSessionBuilder!
    var expectation: XCTestExpectation!

    // MARK: setUp

    override func setUp() {
        // Create URL Session with an array of protocol classes to the configuration
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)

        // Instantiate TransfertService with this url session
        urlSessionBuilder = UrlSessionBuilder(urlSession: urlSession)
        expectation = expectation(description: "UrlSessionBuilder Expectation")
    }

    // MARK: Bad URL

    func testUrlSessionDataTaskFailedBadUrl() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "",
            params: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: nil)
        }
        // When
        Task {
            switch await urlSessionBuilder.createUrlSessionDataTask(config: config) {
            case .success:
                XCTFail("error in testUrlSessionDataTaskFailedBadUrl")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidUrl)
                XCTAssertEqual(failure.title, AppError.invalidUrl.title)
                XCTAssertEqual(failure.message, AppError.invalidUrl.message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: MockData.expectationTimeout)
    }

    // MARK: Bad request

    func testUrlSessionDataTaskFailedBadRequest() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "https//:www.test.com",
            params: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusBadRequest, data: nil)
        }
        // When
        Task {
            switch await urlSessionBuilder.createUrlSessionDataTask(config: config) {
            case .success:
                XCTFail("error in testUrlSessionDataTaskFailedBadRequest")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.badStatusCode)
                XCTAssertEqual(failure.message, AppError.badStatusCode.message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: MockData.expectationTimeout)
    }

    // MARK: Internal Server Error

    func testUrlSessionDataTaskFailedInternalServerError() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "https//:www.test.com",
            params: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusInternalServerError, data: nil)
        }
        // When
        Task {
            switch await urlSessionBuilder.createUrlSessionDataTask(config: config) {
            case .success:
                XCTFail("error in testUrlSessionDataTaskFailedInternalServerError")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.internalServerError)
                XCTAssertEqual(failure.message, AppError.internalServerError.message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: MockData.expectationTimeout)
    }

    // MARK: Invalid Mail or Password

    func testUrlSessionDataTaskFailedInvalidMailOrPwd() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "https//:www.test.com",
            params: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusInvalidMailOrPwd, data: nil)
        }
        // When
        Task {
            switch await urlSessionBuilder.createUrlSessionDataTask(config: config) {
            case .success:
                XCTFail("error in testUrlSessionDataTaskFailedInvalidMailOrPwd")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidMailOrPwd)
                XCTAssertEqual(failure.message, AppError.invalidMailOrPwd.message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: MockData.expectationTimeout)
    }

    // MARK: Bad URL Response

    func testUrlSessionDataTaskFailedBadUrlResponse() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "https//:www.test.com",
            params: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = nil
        // When
        Task {
            switch await urlSessionBuilder.createUrlSessionDataTask(config: config) {
            case .success:
                XCTFail("error in testUrlSessionDataTaskFailedBadUrlResponse")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.badHttpUrlResponse)
                XCTAssertEqual(failure.message, AppError.badHttpUrlResponse.message)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: MockData.expectationTimeout)
    }
}
