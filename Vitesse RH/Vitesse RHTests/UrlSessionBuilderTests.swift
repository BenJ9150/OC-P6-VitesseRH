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
        expectation = expectation(description: "Expectation")
    }

    // MARK: Bad URL

    func testBuildUrlSessionFailedBadUrl() {
        // set config for url session
        let config = UrlSessionBuilder.UrlSessionConfig(
            httpMethod: .get,
            sUrl: "",
            parameters: [:],
            withAuth: false
        )
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: nil)
        }
        // When
        urlSessionBuilder.buildUrlSession(config: config) { result in
            switch result {
            case .success:
                XCTFail("error in testBuildUrlSessionFailedBadUrl")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidUrl)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
