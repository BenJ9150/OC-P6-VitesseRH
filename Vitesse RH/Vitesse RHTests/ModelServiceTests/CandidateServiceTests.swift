//
//  CandidateServiceTests.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 08/03/2024.
//

import XCTest
@testable import Vitesse_RH

final class CandidateServiceTests: XCTestCase {

    var candidateService: CandidateService!
    var expectation: XCTestExpectation!
    let candidateId = "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1"

    let newCandidate = Candidate(id: "1", phone: "0600000000", note: nil,
                                 firstName: "Test", linkedinURL: nil, isFavorite: true,
                                 email: "test@gmail.com", lastName: "Test")

    // MARK: setUp

    override func setUp() {
        // Create URL Session configuration
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]

        // Create url session with this configuration
        let urlSession = URLSession.init(configuration: configuration)

        // Instantiate AuthService with this url session
        candidateService = CandidateService(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    // MARK: - GetCandidates UrlSession Error

    func testGetCandidatesUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await candidateService.getCandidates() {
            case .success:
                XCTFail("error in GetCandidates UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: GetCandidates Invalid Data

    func testGetCandidatesInvalidData() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.incorrectData)
        }
        // When
        Task {
            switch await candidateService.getCandidates() {
            case .success:
                XCTFail("error in GetCandidates Invalid Data")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidJson)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: GetCandidates Success

    func testGetCandidatesSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidatesCorrectData)
        }
        // When
        Task {
            switch await candidateService.getCandidates() {
            case .success(let allCandidates):
                // then
                XCTAssertEqual(allCandidates.count, 2)

            case .failure:
                XCTFail("error in GetCandidates Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - GetCandidateWithId UrlSession Error

    func testGetCandidateWithIdUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await candidateService.getCandidate(WithId: candidateId) {
            case .success:
                XCTFail("error in GetCandidateWithId UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: GetCandidateWithId Invalid Data

    func testGetCandidateWithIdInvalidData() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.incorrectData)
        }
        // When
        Task {
            switch await candidateService.getCandidate(WithId: candidateId) {
            case .success:
                XCTFail("error in GetCandidateWithId Invalid Data")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.invalidJson)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: GetCandidateWithId Success

    func testGetCandidateWithIdSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidateCorrectData)
        }
        // When
        Task {
            switch await candidateService.getCandidate(WithId: candidateId) {
            case .success(let candidate):
                // then
                XCTAssertEqual(candidate.firstName, "Rima")

            case .failure:
                XCTFail("error in GetCandidateWithId Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Create Success

    func testCreateSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidateCorrectData)
        }
        // When
        Task {
            switch await candidateService.add(candidate: newCandidate) {
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

    // MARK: Favorite Success

    func testFavoriteSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.candidateCorrectData)
        }
        // When
        Task {
            switch await candidateService.favoriteToggle(ForId: "test") {
            case .success(let candidate):
                // then
                XCTAssertEqual(candidate.firstName, "Rima")

            case .failure:
                XCTFail("error in Favorite Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: - Delete UrlSession Error

    func testDeleteUrlSessionError() {
        // Given
        MockURLProtocol.requestHandler = {
            throw MockData.urlProtocolRequestError
        }
        // When
        Task {
            switch await candidateService.deleteCandidate(WithId: "test") {
            case .success:
                XCTFail("error in Delete UrlSession Error")

            case .failure(let failure):
                // Then
                XCTAssertEqual(failure, AppError.serverErr)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }

    // MARK: Delete Success

    func testDeleteSuccess() {
        // Given
        MockURLProtocol.requestHandler = {
            return (urlResponse: MockData.statusOK, data: MockData.emptyData)
        }
        // When
        Task {
            switch await candidateService.deleteCandidate(WithId: "test") {
            case .success(let result):
                // then
                XCTAssertTrue(result)

            case .failure:
                XCTFail("error in Delete Success")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
