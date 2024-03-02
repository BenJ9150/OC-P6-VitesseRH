//
//  MockData.swift
//  Vitesse RHTests
//
//  Created by Benjamin LEFRANCOIS on 01/03/2024.
//

import Foundation

final class MockData {

    // MARK: Global

    static let statusOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:]
    )!

    static let badRequest = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 400, httpVersion: nil, headerFields: [:]
    )!

    // MARK: API Error

    // Create class with Error protocol to have instance of Error
    class APIError: Error {}
    static let error = APIError()

    // MARK: Incorrect Data

    static let incorrectData = "erreur".data(using: .utf8)!

    // MARK: Correct Data

    static let authCorrectToken = "EA68E40B-2AE4-40D4-8E86-D8327F4979AA"

    static var authCorrectData: Data {
        return getData(ofFile: "Authentification")
    }
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
