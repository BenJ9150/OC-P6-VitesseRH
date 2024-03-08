//
//  OtherMethodCandidateServiceTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 08/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class OtherMethodCandidateServiceTests: XCTestCase {

    var candidateService: CandidateService!
    var expectation: XCTestExpectation!

    let newCandidate = Candidate(id: "1", phone: "0600000000", note: nil,
                                 firstName: "Test", linkedinURL: nil, isFavorite: true,
                                 email: "test@gmail.com", lastName: "Test")

    // MARK: setUp

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
        candidateService = CandidateService(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    // MARK: - Create UrlSession Error

    func testCreateUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await candidateService.create(candidate: newCandidate) {
            case .success:
                XCTFail("error in Create UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: Create Invalid Data

    func testCreateInvalidData() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.incorrectData)
        }
        // When
        Task {
            switch await candidateService.create(candidate: newCandidate) {
            case .success:
                XCTFail("error in Create Invalid Data")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidJson)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: Create Success

    func testCreateSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidateCorrectData)
        }
        // When
        Task {
            switch await candidateService.create(candidate: newCandidate) {
            case .success(let candidate):
                // then
                XCTAssertEqual(candidate.firstName, "Rima")

            case .failure:
                XCTFail("error in Create Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: Update Success

    func testEditSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidateCorrectData)
        }
        // When
        Task {
            switch await candidateService.update(candidate: newCandidate) {
            case .success(let candidate):
                // then
                XCTAssertEqual(candidate.firstName, "Rima")

            case .failure:
                XCTFail("error in Edit Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
