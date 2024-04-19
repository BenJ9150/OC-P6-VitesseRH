//
//  MockData.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import Foundation
@testable import Vitesse_RH

final class MockData {

    // MARK: Global

    static let statusOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:]
    )!

    static let statusCreated = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 201, httpVersion: nil, headerFields: [:]
    )!

    static let statusBadRequest = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 400, httpVersion: nil, headerFields: [:]
    )!

    static let statusInvalidMailOrPwd = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 401, httpVersion: nil, headerFields: [:]
    )!

    static let statusInternalServerError = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:]
    )!

    // MARK: URLProtocol request error

    // Create class with Error protocol to have instance of Error
    class URLProtocolError: Error {}
    static let urlProtocolRequestError = URLProtocolError()
    static let expectationTimeout: Double = 3

    // MARK: Empty data

    static let emptyData = Data()

    // MARK: Incorrect Data

    static let incorrectData = "erreur".data(using: .utf8)!

    // MARK: Correct Data (Vitesse RH App)

    static let authCorrectToken = "EA68E40B-2AE4-40D4-8E86-D8327F4979AA"

    static var authCorrectData: Data {
        return getData(ofFile: "VitesseAuth")
    }

    static var candidatesCorrectData: Data {
        return getData(ofFile: "Candidates")
    }

    static var candidateCorrectData: Data {
        return getData(ofFile: "Candidate")
    }

    static let candidateId = "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1"

    static let newCandidate = Candidate(
        id: "1",
        phone: "0600000000",
        note: nil,
        firstName: "Test",
        linkedinURL: nil,
        isFavorite: true,
        email: "test@gmail.com",
        lastName: "Test"
    )
}

private extension MockData {

    static func getData(ofFile file: String) -> Data {
        // get bundle for json localization
        let bundle = Bundle(for: MockData.self)
        // get url
        let url = bundle.url(forResource: file, withExtension: "json")
        // get data
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            return Data()
        }
    }
}
